# ADR Preferences

preferred-style: nygard

intent-spec pins Nygard (Status / Context / Decision / Consequences). ADRs sit
downstream of design.md, which already records the alternatives considered, so
Nygard avoids duplicating that analysis. The skill still requires naming the key
rejected option and why, so ADRs stay self-contained.

The other styles under templates/ (madr-full, madr-minimal, y-statement, custom)
remain available — change preferred-style here to switch. Do not re-prompt while a
style is set; do not edit accepted ADRs — supersede them with a new ADR whose
Supersedes field names the prior one.
