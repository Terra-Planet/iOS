const { AnchorEarn,CHAINS, NETWORKS,DENOMS } = require('@anchor-protocol/anchor-earn');
const express = require('express');
const router = express.Router();



router.post('/deposit', async (req, res, next) =>{    
    
    const anchorEarn = new AnchorEarn({
        chain: CHAINS.TERRA,
        network: NETWORKS.BOMBAY_12,
        mnemonic: req.body.mnemonic
      });
    
    anchorEarn.deposit({
        currency: req.body.token,
        amount: req.body.amount
    }).then( (tx)=> {
        res.send(tx);
    }).catch( (err)=> {
        res.status(400).send({'status':'err','msg':err.message})
    })
    
});


router.post('/withdraw', async (req, res, next) =>{   

    const anchorEarn = new AnchorEarn({
        chain: CHAINS.TERRA,
        network: NETWORKS.BOMBAY_12,
        mnemonic: req.body.mnemonic
      });
    anchorEarn.withdraw({
        currency: req.body.token,
        amount: req.body.amount
    }).then( (tx)=> {
        res.send(tx);
    }).catch( (err)=> {
        res.status(400).send({'status':'err','msg':err.message})
    })
    
});


router.post('/balance', async (req, res, next) =>{   

    const anchorEarn = new AnchorEarn({
        chain: CHAINS.TERRA,
        network: NETWORKS.BOMBAY_12,
        mnemonic: req.body.mnemonic
      });
    anchorEarn.balance({
        currencies: [
          DENOMS.UST
        ]
    }).then( (tx)=> {
        res.send({total_deposit_balance_in_ust:tx.total_deposit_balance_in_ust});
    }).catch( (err)=> {
        res.status(400).send({'status':'err','msg':err.message})
    })
    
});


router.post('/market', async (req, res, next) =>{   

    const anchorEarn = new AnchorEarn({
        chain: CHAINS.TERRA,
        network: NETWORKS.BOMBAY_12,
        mnemonic: req.body.mnemonic
      });

    anchorEarn.market({
        currencies: [
          DENOMS.UST
        ]
    }).then( (tx)=> {
        res.send({APY: tx.markets[0].APY*100});
    }).catch( (err)=> {
        res.status(400).send({'status':'err','msg':err.message})
    })
    
});


module.exports = router;