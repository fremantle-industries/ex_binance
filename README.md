# ExBinance
[![Build Status](https://github.com/fremantle-capital/ex_binance/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-capital/ex_binance/actions?query=workflow%3Atest)
[![Coverage Status](https://coveralls.io/repos/github/fremantle-capital/ex_binance/badge.svg?branch=main)](https://coveralls.io/github/fremantle-capital/ex_binance?branch=main)
[![hex.pm version](https://img.shields.io/hexpm/v/ex_binance.svg?style=flat)](https://hex.pm/packages/ex_binance)

Binance API Client for Elixir

## Installation

Add the `ex_binance` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_binance, "~> 0.0.9"}
  ]
end
```

## Requirements

- Erlang 22+
- Elixir 1.11+

## API Documentation

* https://binance-docs.github.io/apidocs/spot/en/#change-log
* https://binance-docs.github.io/apidocs/futures/en/#change-log
* https://binance-docs.github.io/apidocs/delivery/en/#change-log
* https://binance-docs.github.io/apidocs/voptions/en/#change-log

## REST API

### Spot

#### Wallet Endpoints

- [ ] `GET /sapi/v1/system/status`
- [ ] `GET /sapi/v1/capital/config/getall`
- [ ] `GET /sapi/v1/accountSnapshot`
- [ ] `POST /sapi/v1/account/disableFastWithdrawSwitch`
- [ ] `POST /sapi/v1/account/enableFastWithdrawSwitch`
- [ ] `POST /sapi/v1/capital/withdraw/apply`
- [ ] `GET /sapi/v1/capital/deposit/hisrec`
- [ ] `GET /sapi/v1/capital/withdraw/history`
- [ ] `GET /sapi/v1/capital/deposit/address`
- [ ] `GET /sapi/v1/account/status`
- [ ] `GET /sapi/v1/account/apiTradingStatus`
- [ ] `GET /sapi/v1/asset/dribblet`
- [ ] `POST /sapi/v1/asset/dust`
- [ ] `GET /sapi/v1/asset/assetDividend`
- [ ] `GET /sapi/v1/asset/assetDetail`
- [ ] `GET /sapi/v1/asset/tradeFee`
- [ ] `POST /sapi/v1/asset/transfer`
- [ ] `GET /sapi/v1/asset/transfer`
- [ ] `POST /sapi/v1/asset/get-funding-asset`
- [ ] `GET /sapi/v1/account/apiRestrictions`

#### Sub-Account Endpoints

- [ ] `POST /sapi/v1/sub-account/virtualSubAccount`
- [ ] `GET /sapi/v1/sub-account/list`
- [ ] `GET /sapi/v1/sub-account/sub/transfer/history`
- [ ] `GET /sapi/v1/sub-account/futures/internalTransfer`
- [ ] `POST /sapi/v1/sub-account/futures/internalTransfer`
- [ ] `GET /sapi/v3/sub-account/assets`
- [ ] `GET /sapi/v1/sub-account/spotSummary`
- [ ] `GET /sapi/v1/capital/deposit/subAddress`
- [ ] `GET /sapi/v1/capital/deposit/subHisrec`
- [ ] `GET /sapi/v1/sub-account/status`
- [ ] `POST /sapi/v1/sub-account/margin/enable`
- [ ] `GET /sapi/v1/sub-account/margin/account`
- [ ] `GET /sapi/v1/sub-account/margin/accountSummary`
- [ ] `POST /sapi/v1/sub-account/futures/enable`
- [ ] `GET /sapi/v1/sub-account/futures/account`
- [ ] `GET /sapi/v1/sub-account/futures/accountSummary`
- [ ] `GET /sapi/v1/sub-account/futures/positionRisk`
- [ ] `POST /sapi/v1/sub-account/futures/transfer`
- [ ] `POST /sapi/v1/sub-account/margin/transfer`
- [ ] `POST /sapi/v1/sub-account/transfer/subToSub`
- [ ] `POST /sapi/v1/sub-account/transfer/subToMaster`
- [ ] `GET /sapi/v1/sub-account/transfer/subUserHistory`
- [ ] `POST /sapi/v1/sub-account/universalTransfer`
- [ ] `GET /sapi/v1/sub-account/universalTransfer`
- [ ] `GET /sapi/v2/sub-account/futures/account`
- [ ] `GET /sapi/v2/sub-account/futures/accountSummary`
- [ ] `GET /sapi/v2/sub-account/futures/positionRisk`
- [ ] `POST /sapi/v2/sub-account/blvt/enable`
- [ ] `POST /sapi/v1/managed-subaccount/deposit`
- [ ] `POST /sapi/v1/managed-subaccount/asset`
- [ ] `POST /sapi/v1/managed-subaccount/withdraw`

#### Market Data Endpoints

- [x] `GET /api/v3/ping`
- [x] `GET /api/v3/time`
- [x] `GET /api/v3/exchangeInfo`
- [x] `GET /api/v3/depth`
- [ ] `GET /api/v3/trades`
- [ ] `GET /api/v3/historicalTrades`
- [ ] `GET /api/v3/aggTrades`
- [ ] `GET /api/v3/klines`
- [ ] `GET /api/v3/avgPrice`
- [ ] `GET /api/v3/ticker/24hr`
- [x] `GET /api/v3/ticker/price`
- [ ] `GET /api/v3/ticker/bookTicker`

#### Spot Account/Trade

- [ ] `POST /api/v3/order/test`
- [x] `POST /api/v3/order`
- [x] `DELETE /api/v3/order`
- [x] `DELETE /api/v3/openOrders`
- [x] `GET /api/v3/order`
- [ ] `GET /api/v3/openOrders`
- [ ] `GET /api/v3/allOrders`
- [ ] `POST /api/v3/order/oco`
- [ ] `DELETE /api/v3/orderList`
- [ ] `GET /api/v3/orderList`
- [ ] `GET /api/v3/allOrderList`
- [ ] `GET /api/v3/openOrderList`
- [ ] `GET /api/v3/account`
- [ ] `GET /api/v3/myTrades`

#### Margin Account/Trade

- [ ] `POST /sapi/v1/margin/transfer`
- [ ] `POST /sapi/v1/margin/loan`
- [ ] `POST /sapi/v1/margin/repay`
- [ ] `GET /sapi/v1/margin/asset`
- [ ] `GET /sapi/v1/margin/pair`
- [ ] `GET /sapi/v1/margin/allAssets`
- [ ] `GET /sapi/v1/margin/allPairs`
- [ ] `GET /sapi/v1/margin/priceIndex`
- [ ] `POST /sapi/v1/margin/order`
- [ ] `DELETE /sapi/v1/margin/order`
- [ ] `DELETE /sapi/v1/margin/openOrders`
- [ ] `GET /sapi/v1/margin/transfer`
- [ ] `GET /sapi/v1/margin/loan`
- [ ] `GET /sapi/v1/margin/repay`
- [ ] `GET /sapi/v1/margin/interestHistory`
- [ ] `GET /sapi/v1/margin/forcedLiquidationRec`
- [ ] `GET /sapi/v1/margin/account`
- [ ] `GET /sapi/v1/margin/order`
- [ ] `GET /sapi/v1/margin/openOrders`
- [ ] `GET /sapi/v1/margin/allOrders`
- [ ] `GET /sapi/v1/margin/myTrades`
- [ ] `GET /sapi/v1/margin/maxBorrowable`
- [ ] `GET /sapi/v1/margin/maxTransferable`
- [ ] `POST /sapi/v1/margin/isolated/transfer`
- [ ] `GET /sapi/v1/margin/isolated/transfer`
- [ ] `GET /sapi/v1/margin/isolated/account`
- [ ] `GET /sapi/v1/margin/isolated/pair`
- [ ] `GET /sapi/v1/margin/isolated/allPairs`
- [ ] `POST /sapi/v1/bnbBurn`
- [ ] `GET /sapi/v1/bnbBurn`
- [ ] `GET /sapi/v1/margin/interestRateHistory`

#### User Data Stream Endpoints

- [ ] `POST /api/v3/userDataStream`
- [ ] `PUT /api/v3/userDataStream`
- [ ] `DELETE /api/v3/userDataStream`
- [ ] `POST /sapi/v1/userDataStream`
- [ ] `PUT /sapi/v1/userDataStream`
- [ ] `DELETE /sapi/v1/userDataStream`
- [ ] `POST /sapi/v1/userDataStream/isolated`
- [ ] `PUT /sapi/v1/userDataStream/isolated`
- [ ] `DELETE /sapi/v1/userDataStream/isolated`

#### Savings Endpoints

- [ ] `GET /sapi/v1/lending/daily/product/list`
- [ ] `GET /sapi/v1/lending/daily/userLeftQuota`
- [ ] `POST /sapi/v1/lending/daily/purchase`
- [ ] `GET /sapi/v1/lending/daily/userRedemptionQuota`
- [ ] `POST /sapi/v1/lending/daily/redeem`
- [ ] `GET /sapi/v1/lending/daily/token/position`
- [ ] `GET /sapi/v1/lending/project/list`
- [ ] `POST /sapi/v1/lending/customizedFixed/purchase`
- [ ] `GET /sapi/v1/lending/project/position/list`
- [ ] `GET /sapi/v1/lending/union/account`
- [ ] `GET /sapi/v1/lending/union/purchaseRecord`
- [ ] `GET /sapi/v1/lending/union/redemptionRecord`
- [ ] `GET /sapi/v1/lending/union/interestHistory`
- [ ] `POST /sapi/v1/lending/positionChanged`

#### Mining Endpoints

- [ ] `GET /sapi/v1/mining/pub/algoList`
- [ ] `GET /sapi/v1/mining/pub/coinList`
- [ ] `GET /sapi/v1/mining/worker/detail`
- [ ] `GET /sapi/v1/mining/worker/list`
- [ ] `GET /sapi/v1/mining/payment/list`
- [ ] `GET /sapi/v1/mining/payment/other`
- [ ] `GET /sapi/v1/mining/hash-transfer/config/details/list`
- [ ] `GET /sapi/v1/mining/hash-transfer/profit/details`
- [ ] `POST /sapi/v1/mining/hash-transfer/config`
- [ ] `POST /sapi/v1/mining/hash-transfer/config/cancel`
- [ ] `GET /sapi/v1/mining/statistics/user/status`
- [ ] `GET /sapi/v1/mining/statistics/user/list`

### USD-M Futures

#### Market Data Endpoints

- [x] `GET /fapi/v1/ping`
- [x] `GET /fapi/v1/time`
- [ ] `GET /fapi/v1/exchangeInfo`
- [ ] `GET /fapi/v1/depth`
- [ ] `GET /fapi/v1/trades`
- [ ] `GET /fapi/v1/historicalTrades`
- [ ] `GET /fapi/v1/aggTrades`
- [ ] `GET /fapi/v1/klines`
- [ ] `GET /fapi/v1/continuousKlines`
- [ ] `GET /fapi/v1/indexPriceKlines`
- [ ] `GET /fapi/v1/markPriceKlines`
- [ ] `GET /fapi/v1/premiumIndex`
- [ ] `GET /fapi/v1/fundingRate`
- [ ] `GET /fapi/v1/ticker/24hr`
- [ ] `GET /fapi/v1/ticker/price`
- [ ] `GET /fapi/v1/ticker/bookTicker`
- [ ] `GET /fapi/v1/openInterest`
- [ ] `GET /futures/data/openInterestHist`
- [ ] `GET /futures/data/topLongShortAccountRatio`
- [ ] `GET /futures/data/topLongShortPositionRatio`
- [ ] `GET /futures/data/globalLongShortAccountRatio`
- [ ] `GET /futures/data/takerlongshortRatio`
- [ ] `GET /fapi/v1/lvtKlines`
- [ ] `GET /fapi/v1/indexInfo`

#### Account/Trades Endpoints

### Coin-M Futures

#### Market Data Endpoints

- [ ] `GET /dapi/v1/ping`
- [ ] `GET /dapi/v1/time`
- [ ] `GET /dapi/v1/exchangeInfo`
- [ ] `GET /dapi/v1/depth`
- [ ] `GET /dapi/v1/trades`
- [ ] `GET /dapi/v1/historicalTrades`
- [ ] `GET /dapi/v1/aggTrades`
- [ ] `GET /dapi/v1/premiumIndex`
- [ ] `GET /dapi/v1/fundingRate`
- [ ] `GET /dapi/v1/klines`
- [ ] `GET /dapi/v1/continuousKlines`
- [ ] `GET /dapi/v1/indexPriceKlines`
- [ ] `GET /dapi/v1/markPriceKlines`
- [ ] `GET /dapi/v1/ticker/24hr`
- [ ] `GET /dapi/v1/ticker/price`
- [ ] `GET /dapi/v1/ticker/bookTicker`
- [ ] `GET /dapi/v1/openInterest`
- [ ] `GET /futures/data/openInterestHist`
- [ ] `GET /futures/data/topLongShortAccountRatio`
- [ ] `GET /futures/data/topLongShortPositionRatio`
- [ ] `GET /futures/data/globalLongShortAccountRatio`
- [ ] `GET /futures/data/takerBuySellVol`
- [ ] `GET /futures/data/basis`

#### Account/Trades Endpoints

### Vanilla Options

## Authors

* Alex Kwiatkowski - alex+git@fremantle.io

## License

`ex_binance` is released under the [MIT license](./LICENSE)
