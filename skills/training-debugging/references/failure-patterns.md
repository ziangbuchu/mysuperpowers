# Failure Patterns

## NaNs or infs

- Check inputs for invalid values before the model.
- Log activation and loss ranges layer by layer.
- Disable mixed precision once to determine whether overflow is the trigger.
- Inspect normalization denominators, logs, square roots, and softmax masks.

## Loss explodes immediately

- Verify target scaling and label encoding.
- Compare learning rate, batch size, and effective batch size against the baseline.
- Run one batch repeatedly; if it still explodes, the issue is not data ordering.

## OOM or memory creep

- Measure peak memory after forward, backward, and optimizer step.
- Check for tensors stored in Python lists, logs, or closures.
- Confirm checkpointing, AMP, and activation saves match expectations.

## Validation metrics are too good

- Suspect leakage first.
- Verify split construction, sampler behavior, augmentation differences, and cached artifacts.
- Check whether model selection used test data directly or indirectly.

## Distributed mismatch

- Confirm per-rank batch composition and reduction semantics.
- Check whether metrics are averaged correctly across devices.
- Verify random seeding and shuffling per worker.
