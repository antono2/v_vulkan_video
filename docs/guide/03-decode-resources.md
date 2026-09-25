# 3. Give codec references and display images separate lifetimes

Vulkan Video makes the application describe and own resources that a
high-level media API might hide. The important design question is which
resource belongs to the codec, which belongs to presentation, and what must
remain valid while commands are in flight.

## Build the session from parsed limits

[`Decoder.initialize`](../../decoder_session.v#L8) asks the selected device for H.264
capabilities and supported formats. Device selection has already
[checked the stream's extent and reference limits](../../device_context.v#L526).
Session setup confirms those values and allocates an aligned bitstream
buffer, [creates a `VideoSessionKHR`](../../decoder_session.v#L125), queries its opaque memory requirements,
binds that memory, and creates session parameters from SPS/PPS data. The
alignment used for each upload slot comes from the queried minimum bitstream
offset and size alignments. [`write_video_frame`](../../player_decode.v#L560) fills
one slot with the next access unit and its slice offsets.

The DPB stores reference pictures for later H.264 predictions. A picture that
is no longer needed as a reference may free a DPB slot even if its display
time has not arrived. Conversely, a displayed picture may still be referenced
by later decode operations. This is why the app copies decode results into a
separate bounded pool of [`OutputImage`](../../video_player.v#L308) objects,
[allocated after decoder setup](../../video_player.v#L684). The
graphics side samples that pool, not a DPB slot whose codec lifetime it does
not control.

The [DPB marking helper](../../video_player.v#L215) applies sliding-window
marking and MMCO 1–6, including long-term indices. The player invokes it
[after recording the decode](../../player_decode.v#L159), so the current
picture still sees the old references. MMCO 5 clears older references and
renumbers the current picture. For a long-term reference, the
[Vulkan slot information](../../player_decode.v#L474) carries its index in
`FrameNum` and sets `used_for_long_term_reference`. The
[software marking test](../../video_player_test.v#L189) covers removal,
conversion, and long-term limits.

Progressive H.264 pictures still have separate top and bottom order counts.
The [decode command](../../player_decode.v#L106) passes both to Vulkan, and
the [DPB slot data](../../player_decode.v#L75) retains both for later references.
An MMCO 5 picture uses its original counts for the current decode, then
[normalizes its stored reference](../../video_player.v#L170) for subsequent
pictures.

In coincident mode, the copy source is the current DPB image. In distinct
mode, the copy source is a separate decode-output image; the DPB remains
reference storage. [`copy_decoded_frame_to_output`](../../player_decode.v#L204)
selects the correct source and restores its decode layout after the copy.

```mermaid
flowchart LR
    Bits[Aligned bitstream slot] --> Session[Video session]
    Params[SPS/PPS session parameters] --> Session
    Session --> DPB[DPB reference images]
    Session --> Distinct[Separate decode output when required]
    DPB --> Copy[Copy into display-owned image]
    Distinct --> Copy
    Copy --> Ready[Ready output queue]
```

**Invariant:** a DPB slot cannot be overwritten while the codec still needs
it, and an output image cannot be reused while graphics may still sample it.
Those rules are related but have different owners.

## Other ownership choices

| Choice | Where it can fit | Constraint |
| --- | --- | --- |
| Copy to a separate display pool, as here | A compact player that wants an explicit presentation queue and simple sampling ownership. | Extra image memory and a per-picture copy. |
| Share decoded images directly with rendering | A pipeline whose decoder and renderer can coordinate image lifetime precisely. | Reference, display, queue, and descriptor lifetimes must all be tracked together. |
| Use a higher-level decoder API | Broad codec support or faster integration. | Less direct control of Vulkan Video session setup and possibly an interop copy. |

For another project, calculate the bound from reorder depth, concurrent
uploads, and frames still sampled by graphics. A fixed pool is safe only if
the producer pauses when no image is reusable. Here
[the free-pool check](../../player_presentation.v#L128) pauses before
starting another decode.
