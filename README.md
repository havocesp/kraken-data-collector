# KRAKEN DATA COLLECTOR
---
**AUTHOR:**  _Daniel J. Umpierrez_
**VERSION:** _0.01_

### *A fast and simple cryptocurrency pair data collector from Kraken Exchange.*
---
## DESCRIPTION
Data is not provided by Kraken because official wat to get this kind of data
from Kraken wwith OHCL API command has been limited to a insuficient interval,
in other words, if you are planning to do some backtesting using data from
oficial sources keep in mind to let your computer requesting and storing OHLC
data for a while.

## DATA VOLUMEN RESTRICTION
There is a 7 days data interval limit whet period param is provided in minutes, this is, it is not possiblle to get more than 7 days  whet period is set to 5 or 15 minutes for example.

## ROADMAP
*Version 0.02*
- Add support to all asset pairs (no more BTC/EUR asset pair restriction)
- Optional argument. Directory path where data will be dumped.
- Optional argument. 5, 15 and 30 minutes periods are now accepted as argument.
acepted). to specify period size in minutes     Period from .

## CHANGELOG
*Version 0.01*
- Dump to CSV file a maximum of 7 days OHLC data from TODO site. This version
only get BTC/EUR asset pair data for 5, 15 and 30 minutes periods.

---
