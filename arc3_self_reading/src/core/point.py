from dataclasses import dataclass
from typing import Any, Tuple, Optional

@dataclass(frozen=True)
class CompletionPoint:
    state: Any
    code: Any
    current: Any
    next_action: Any
    continuation: tuple
    halt: bool
