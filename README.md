<!-- badges: start -->
  [![R-CMD-check](https://github.com/nrennie/national-highways/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nrennie/national-highways/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# National Highways

This repository pulls data from the [National Highways WebTRIS API](https://webtris.highwaysengland.co.uk/api/swagger/ui/index).

Currently, National Highways directly monitor the speed and flow of roads using on road sensors which fall into the following categories:

* MIDAS sites (Motorway Incident Detection and Automatic Signalling) which are predominantly inductive loops. 
* TMU sites (Traffic Monitoring Units) which are inductive loops.
* TAME sites (Traffic Appraisal, Modelling and Economics) which are inductive loops.
* TRADS Legacy sites.

## Installation

Install from GitHub:

```r
pak::pak::pkg_install("nrennie/national-highways")
```
