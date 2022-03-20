# SmartContract Lottery

Smart Contract for creating a Lottery that maps an address with a username

@TODO 
-> Add funds and enable liquidity

## Prerequisites

Installation :

- [nodejs and npm](https://nodejs.org/en/download/)
- [python](https://www.python.org/downloads/)

- Install Brownie : 
```bash
pip install eth-brownie
```

- Install ChainLink Dependencies

```bash
git clone https://github.com/PatrickAlphaC/chainlink-mix
cd chainlink-mix 
```

```bash
brownie bake chainlink-mix
cd chainlink-mix
pip install -r requirements.txt
```

### Environment variables

Set `WEB3_INFURA_PROJECT_ID`, and `PRIVATE_KEY`
=> [Infura](https://infura.io/).

```
export WEB3_INFURA_PROJECT_ID=<PROJECT_ID>
export PRIVATE_KEY=<PRIVATE_KEY>
```

AND THEN RUN `source .env` 

## Local Development

```bash
npm install -g ganache-cli
```

and then : 

```
brownie networks add Ethereum ganache host=http://localhost:8545 chainid=1337
```

## Deploy to a testnet

```
brownie run scripts/1_deploy_lottery.py
brownie run scripts/2_start_lottery.py
brownie run scripts/3_enter_lottery.py
brownie run scripts/4_end_lottery.py
```

## Testing

```
brownie test
```

```
brownie test --network <network>
```

### Local development

```bash
brownie test
```
### Mainnet fork

```bash
brownie test --network mainnet-fork
```
