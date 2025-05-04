---
date: '2025-05-04T16:55:19-04:00'
title: '2025 05 04 Lol Wut'
summary: "Debugging Hugo image processing and template leaks."
---

{{%/* markdown */%}}
{{ with .Resources.Get "beetle-after-fire.jpg" }}
  {{ $resized := .Resize "800x" }}
  <img src="{{ $resized.RelPermalink }}" alt="Beetle After the Fire" loading="lazy">
{{ else }}
  <p><em>Beetle image missing.</em></p>
{{ end }}
{{%/* /markdown */%}}

----

bravo -
{{%/* markdown */%}}
{{ with .Resources.Get "bravo.jpg" }}
  {{ $resized := .Resize "800x" }}
  <img src="{{ $resized.RelPermalink }}" alt="Bravo image" loading="lazy">
{{ else }}
  <p><em>Bravo image missing.</em></p>
{{ end }}
{{%/* /markdown */%}}

YET ANOTHER IMAGES NOT WORKING
