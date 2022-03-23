const { LCDClient, MnemonicKey,MsgSwap,Coin,Fee,MsgSend } = require('@terra-money/terra.js');

const terra = new LCDClient({
    URL: 'https://bombay-lcd.terra.dev',
    chainID: 'bombay-12',    
});

const express = require('express');
const router = express.Router();


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
    const balance=await terra.bank.balance(req.params.acc_address);  
    //testnet aUST contract. use envs!
    const anchor_balance=await terra.wasm.contractQuery('terra1ajt556dpzvjwl0kl5tzku3fc3p3knkg9mkv8jl', { balance: { address: req.params.acc_address } })  
    res.send({native:balance,anchor:anchor_balance});
}); 

router.post('/swap/preview', async (req, res, next) =>{    
    
    const swap_rate = await terra.market.swapRate(new Coin(req.body.src,req.body.amount),req.body.dst)

    res.send({
        'amount':swap_rate.amount,
        'denom':swap_rate.denom
    })
});


router.post('/swap', async (req, res) =>{    
        
    const fee = new Fee(550000, { uluna: 500000 });
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);
    
    const swap = new MsgSwap(
        wallet.key.accAddress,
        new Coin(req.body.src, req.body.amount * 10 ** 6 ),
        req.body.dst
    );

    wallet.createAndSignTx({ msgs: [swap], fee : fee  }).then ( (tx) => {
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
    
});


router.post('/send/preview', async (req, res) =>{   
    const fee = new Fee(550000, { uluna: 500000 });
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);

    //console.log(wallet.key.accAddress)
    const send = new MsgSend(
        wallet.key.accAddress,
        req.body.dst_addr,
        { [req.body.token]: req.body.amount * 10 ** 6 }
    );
    
    wallet.createTx({ msgs: [send], fee : fee  }).then ( (tx) => {
        res.send(tx);
    }).catch ( (err) => {
        res.status(400).send({status:'err',msg:err.message})
    });
});

router.post('/send', async (req, res) =>{   
    const fee = new Fee(550000, { uluna: 500000 });
    const mk = new MnemonicKey({mnemonic:req.body.mnemonic});
    const wallet = terra.wallet(mk);

    //console.log(wallet.key.accAddress)
    const send = new MsgSend(
        wallet.key.accAddress,
        req.body.dst_addr,
        { [req.body.token]: req.body.amount * 10 ** 6 }
    );
    
    wallet.createAndSignTx({ msgs: [send], fee : fee  }).then ( (tx) => {
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
});

module.exports = router;
