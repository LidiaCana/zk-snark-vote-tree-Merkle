pragma circom 2.0.0;

include "circomlib/circuits/poseidon.circom";

template hashLeaves() {
    signal input leftLeaf;
    signal input rightLeaf;
    signal output root;
    component poseidonComponent;
    poseidonComponent = Poseidon(2);
    poseidonComponent.inputs[0] <== leftLeaf;
    poseidonComponent.inputs[1] <== rightLeaf;
    root <== poseidonComponent.out;
    log(root);
}

component main = hashLeaves();