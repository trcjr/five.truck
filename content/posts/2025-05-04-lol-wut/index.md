---
date: '2025-05-04T16:55:19-04:00'
title: '2025 05 04 Lol Wut'
summary: "Debugging Hugo image processing and template leaks."
---


Ok so here is a picture of the car after a fire happened or whatever

| image with alt text | alt text only | notes |
| ----- | ----- | ----- |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="10x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 10x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="20x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 20x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="200x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 200x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="400x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 400x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="800x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 800x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="80x" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 80x | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="80%" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 80% | |
| {{< resize-img src="beetle-after-fire.jpg" alt="Beetle After Fire" width="8%" >}} Aftermath of the incident ALT TEXT {{< /resize-img >}} | 8% | |
| fake img | fake alt | notes |

FIN
