# Smart Contracts Account

The smart contracts have a modular structure, wherein each functionality is added as a module with an ease to remove or add new features whenever the owner wishes. The factory contract clones the base contract each time a new user wishes to create his copy. This provides user with a given set of functionalities like batch transactions, MEV resistant swapping, multiple auths, etc. The modular and upgradeable structure of smart accounts allows the manager/owner to add or remove any module. The fallback method takes care of the all the calls and the implementations.
In future other functionalities like meta-tx, gas relayer etc can also be added to make it even more compatible with the upcoming developemnts.

The call structure:

```
EOA --> smart contract account --> search for function in contract --> if present execute the function on behalf of EOA.
                                               |
                                        if not present, go to fallback
                                        and check if implementation module
                                        exists, if yes make a delegatecall
                                        to the module, else revert.
```

### To compile,
```
forge build
```
