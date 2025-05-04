---
date: '2025-05-04T12:15:11-04:00'
draft: false
title: 'MAOR IMAGES NOT WORKINT'
---

{{ $image := resources.Get "beetle-after-fire.jpg" | resources.ImageFilter "quality=80" }}
{{ $image.Resize "800x" }}
{{< figure src="{{ $image.RelPermalink }}" alt="Beetle After the Fire" >}}

YET ANOTHER IMAGES NOT WORKING

