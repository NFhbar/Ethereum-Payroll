# Smart Contract Payroll

Payroll Smart Contract with [Truffle](https://github.com/trufflesuite/truffle-core) and
[Zeppelin Solidity](https://github.com/OpenZeppelin/zeppelin-solidity). It allows an owner to
manage employees. Employees can request payment in tokens for given pay periods.

## Install
- [Truffle](https://github.com/trufflesuite/truffle-core)
```
npm install
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

## Notes
The pay period is simple an uint but it could easily be set to an actual time frame
if needed.

## License
[MIT](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE)
