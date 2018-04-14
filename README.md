# Smart Contract Payroll

<div>

[![Build Status](https://travis-ci.org/NFhbar/payroll.png?branch=master)](https://travis-ci.org/NFhbar/payroll)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/NFhbar/payroll/issues)

</div>

Payroll Smart Contract with [Truffle](https://github.com/trufflesuite/truffle-core) and
[Zeppelin Solidity](https://github.com/OpenZeppelin/zeppelin-solidity). It allows an owner to
manage employees. Employees can request payment in tokens for given pay periods.

## Install
Clone repo:
```
git clone git@github.com:NFhbar/Ethereum-Payoll.git
```
Create a new ```.env``` file in root directory and add your private key:
```
RINKEBY_PRIVATE_KEY="MyPrivateKeyHere..."
```
If you don't have a private key, you can use one provided by Ganache (for development only!):
```
RINKEBY_PRIVATE_KEY="c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3"
```

## Run
In project folder run:
```
$ truffle develop
```
Then in truffle develop console compile the contracts:
```
truffle(develop)> compile
```
Finally migrate:
```
truffle(develop)> migrate
```
To test:
```
truffle(develop)> test
```

## Coverage
### Solidity Coverage
To run [Solidity Coverage reports](https://github.com/sc-forks/solidity-coverage):
```
$ npm run coverage
```
Keep in mind solidity-coverage now expects a globally installed truffle.
Coverage report available [here](https://github.com/NFhbar/Ethereum-Payroll/blob/master/coverage).

## Notes
The pay period is simple an uint but it could easily be set to an actual time frame
if needed.

## Issues/Bugs
### Wrong Contract Address
When migrating
```
Error: Attempting to run transaction which calls a contract function, but recipient address 0x8cdaf0cd259887258bc13a92c0a6da92698644c0 is not a contract address
```
Solution: delete contents of /build/contracts and recompile.

### Not Enough Funds during test
When testing in truffle develop
```
Error: sender doesn't have enough funds to send tx.
```
Solution: restart truffle develop.
Notes: truffle does not reset accounts balance on multiple runs.

### Solidity Coverage testrpc ghost process
After running solidity-coverage, testrpc remains a ghost process.
Solution: kill it with:
```
$ npm run stop
```
and run coverage again:
```
$ npm run coverage
```

## License
[MIT](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE)
