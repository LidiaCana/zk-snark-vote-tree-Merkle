# zk-snark-vote-tree-Merkle

This is an example of how to build an onChain voting system that uses zk tests to determine if a user is an authorized member.

We accomplish it through the tree Merkle data structure.

What is a tree Merkle?

A Merkle tree, also known as a hash tree, is a data structure used in computer science and cryptography. It is a tree where every leaf node is a hash of a data block, and every non-leaf node is a hash of its child nodes. This structure ensures data integrity and efficient verification of large datasets.

![Tree Merkle](https://file%2B.vscode-resource.vscode-cdn.net/Users/lidiacanales/Desktop/personal/web3/ck-vote-system/docs/Screenshot%202024-07-24%20at%2016.24.49.png?version%3D1721883147712)

Our circuit will allow us to vote generating a public key built off chain from your private key, and generate a proof. The proof will be passed as parameter to a on chain contract.
