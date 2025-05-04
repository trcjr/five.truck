---
date: '2025-05-04T12:15:11-04:00'
draft: false
title: 'MAOR IMAGES NOT WORKINT'
---

{{ $image := resources.Get "beetle-after-fire.jpg" }}
{{ $resized := $image.Resize "800x" }}

<img src="{{ $resized.RelPermalink }}" alt="Beetle After the Fire" loading="lazy">
<noscript><p>Image of a beetle after the fire (beetle-after-fire.jpg)</p></noscript>

YET ANOTHER IMAGES NOT WORKING

