# mpesa

Mpesa package changelog

## [2.0.0] - 24/05/2021

* `clientKey`,`clientSecret` and `environment` are now public.
* `securityCredential` is no longer required for Lipa Na Mpesa Online

### Breaking Changes

* Migrate to null-safety
* Requires dart version `>=2.12.0 <3.0.0`
* Calling `lipaNaMpesa` method now returns `Future<MpesaResponse>` instead of `Future<Map<dynamic,dynamic>>`
  
## [1.0.0] - 29/8/2019

* Stable release
* Shipped Lipa Na Mpesa method
* Improved docs

## [0.0.4-dev.1] - 29/8/2019

* Rewrite to support plain dart without flutter

## [0.0.3] - 14/8/2019

* Some tweaking.

## [0.0.2] - 14/8/2019

* Added barebones Lipa na Mpesa method

## [0.0.1] - 14/8/2019

* Init to win it
