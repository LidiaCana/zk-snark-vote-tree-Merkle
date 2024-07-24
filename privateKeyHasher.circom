pragma circom 2.0.0;

include "circomlib/circuits/poseidon.circom";

template privateKeyHasher() {
    signal input privateKey;
    signal output publicKey;
    component poseidonComponent;
    poseidonComponent = Poseidon(1);
    poseidonComponent.inputs[0] <== privateKey;
    publicKey <== poseidonComponent.out;
    log(publicKey);
}

component main = privateKeyHasher();