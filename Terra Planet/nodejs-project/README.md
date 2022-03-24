# terraplanet_backend

To run:

1. npm install
2. node ./bin/www 


## Endpoints

**GET** /server/status

**GET** /wallet/create

**GET** /wallet/rate/<token_in>/<token_out>

**GET** /wallet/balance/<wallet_addr>


**POST** /wallet/send[/preview]

E.g. payload:

```
{   
    "fee_token" "uluna",
    "token":"uluna",
    "amount":"1",
    "dst_addr":"terra1y5ryvemxasn5uz7p44nhgdg94r2rmzz5e2k64t",
    "mnemonic":"reject govern sort strategy hunt lunar crunch suspect rain essay maid pill horse main usage term near shock drastic gauge dad belt normal chronic"
}
```


**POST** /wallet/swap[/preview]

E.g. payload:

```
{
    "fee_token": "uusd",
    "mnemonic": "rough simple snap arrest jazz region people combine abuse coyote use camera second parent mimic smile empower daring guess bacon enlist nose anchor spatial",
    "src":"uluna",
    "amount":"1",
    "dst":"uusd"
}
```

**POST** /anchor/deposit

E.g. payload:

```
{
    "mnemonic": "reject govern sort strategy hunt lunar crunch suspect rain essay maid pill horse main usage term near shock drastic gauge dad belt normal chronic",    
    "amount":"150",
    "token":"uusd"
}
```


**POST** /anchor/withdraw

E.g. payload:

```
{
    "mnemonic": "reject govern sort strategy hunt lunar crunch suspect rain essay maid pill horse main usage term near shock drastic gauge dad belt normal chronic",    
    "amount":"150",
    "token":"uusd"
}
```

**POST** /anchor/balance
**POST** /anchor/market

E.g. payload:

```
{
    "mnemonic": "reject govern sort strategy hunt lunar crunch suspect rain essay maid pill horse main usage term near shock drastic gauge dad belt normal chronic"
}
```


