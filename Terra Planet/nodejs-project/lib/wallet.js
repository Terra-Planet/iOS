const { LCDClient, MnemonicKey,MsgSwap,Coin,Fee,MsgSend } = require('@terra-money/terra.js');
require('isomorphic-fetch');
const terra = new LCDClient({
    URL: 'https://bombay-lcd.terra.dev',
    chainID: 'bombay-12',    
});

const express = require('express');
const router = express.Router();

async function get_gas_prices(token) {
    const gasPrices = await (await fetch('https://bombay-fcd.terra.dev/v1/txs/gas_prices')).json();
    return {
        [token]: gasPrices[token]
    };
}

router.get('/create', function(req, res) {
    const mk = new MnemonicKey();
    const wallet = terra.wallet(mk);

    res.send({
        'acc_address':wallet.key.accAddress,
        'mnemonic':mk.mnemonic
    });
}); 


router.get('/rate/:token_in/:token_out', function(req, res) {
    terra.market.swapRate(new Coin(req.params.token_in,1),req.params.token_out).then ( (r)=> {        
        res.send({token:r.denom, amount:r.amount});
    }).catch ( (err) => {
        res.status(400).send({status:'err',msg:err.message});
    });
}); 


router.get('/balance/:acc_address', async (req, res) =>{
    terra.bank.balance(req.params.acc_address).then( (balance) => { 
        res.send({native:balance});
    }).catch ( (err) => {
        res.status(400).send({status:'err',msg:err.message});
    });    
}); 


router.post('/swap', async (req, res) =>{            
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);
    
    const swap = new MsgSwap(
        wallet.key.accAddress,
        new Coin(req.body.src, req.body.amount * 10 ** 6 ),
        req.body.dst
    );


    get_gas_prices(req.body.fee_token).then ( (gas_prices) => {
        wallet.createAndSignTx({ msgs: [swap], gasPrices: gas_prices}).then ( (tx) => {
            terra.tx.broadcast(tx).then( (result) => {
                if (result.height==0) {
                    res.status(400).send({'status':'failed','msg':result.raw_log}).end()
                    return;
                }        
                res.send(result);
            }).catch( (err)=> {
                res.status(400).send({status:'broadcast_err',msg:err.message});
            });
        }).catch( (err)=> {
            res.status(400).send({status:'create_and_sign_err',msg:err.message});
        });    
    }).catch( (err)=> {
        res.status(400).send({status:'get_gas_prices',msg:err.message});
    });    
});


router.post('/swap/preview', async (req, res) =>{            
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);
    
    const swap = new MsgSwap(
        wallet.key.accAddress,
        new Coin(req.body.src, req.body.amount * 10 ** 6 ),
        req.body.dst
    );
    
    get_gas_prices(req.body.fee_token).then ( (gas_prices) => {
        wallet.createTx({ msgs: [swap], gasPrices: gas_prices}).then ( (tx) => {    
            res.send(tx);        
        }).catch( (err)=> {
            res.status(400).send({status:'create_and_sign_err',msg:err.message});
        });    
    }).catch( (err)=> {
        res.status(400).send({status:'get_gas_prices',msg:err.message});
    });    
    
});


router.post('/send/preview', async (req, res) =>{       
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);

    const send = new MsgSend(
        wallet.key.accAddress,
        req.body.dst_addr,
        { [req.body.token]: req.body.amount * 10 ** 6 }
    );
    
    get_gas_prices(req.body.fee_token).then ( (gas_prices) => {
        wallet.createTx({ msgs: [send], gasPrices: gas_prices  }).then ( (tx) => {
            res.send(tx);
        }).catch ( (err) => {
            res.status(400).send({status:'err',msg:err.message})
        });
    }).catch( (err)=> {
        res.status(400).send({status:'get_gas_prices',msg:err.message});
    });    
});


router.post('/send', async (req, res) =>{       
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);
    
    const send = new MsgSend(
        wallet.key.accAddress,
        req.body.dst_addr,
        { [req.body.token]: req.body.amount * 10 ** 6 }
    );
    
    get_gas_prices(req.body.fee_token).then ( (gas_prices) => {
        wallet.createAndSignTx({ msgs: [send], gasPrices: gas_prices }).then ( (tx) => {
            terra.tx.broadcast(tx).then( (result) => {
                if (result.height==0) {
                    res.status(400).send({'status':'failed','msg':result.raw_log}).end()
                    return;
                }        
                res.send(result);
            }).catch( (err)=> {
                res.status(400).send({status:'broadcast_err',msg:err.message});
            });
        }).catch( (err)=> {
            res.status(400).send({status:'create_and_sign_err',msg:err.message});
        });    
    }).catch( (err)=> {
        res.status(400).send({status:'get_gas_prices',msg:err.message});
    });    
});


module.exports = router;