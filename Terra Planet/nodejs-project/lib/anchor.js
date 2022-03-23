const { AnchorEarn,CHAINS, NETWORKS } = require('@anchor-protocol/anchor-earn');
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

module.exports = router;