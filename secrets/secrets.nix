let
  gateUserQ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4duy6jXTVgjst3f9zHNMKxWodvXc2aN1JV0uh/9Zyi";
  gateHostRSA = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuX52iMkhdh/ceuPHhNXY4O87gZHncjiwlx54SwpOPXV4+WeucPMpc5QlZf25xG+GZzLjgrt56OvWYiIrfmeCHXhI6nwC7SIx73D2fa6QYsRw4lyV7alnm+sFUem+OM1ZS/eX7eHkPDodarLflZnX9QlisfqpT5x+/pL30+LG9yIUArfE67MquFWr98RjTu95uYQjBrbR/yqiUTOiv3s2gjUPeaSBr+9/PTmdFkphi2OJomY/bdIulsZ07IByDCYQWCvcuQW885ejAl0RxgEv1RNUDm7UY8JSQ105BVGI9mlkxaD6gMwXgxXZAGBsXASESLLdW535W69eHvp47MWemFD1TP9AdGf9o1zw9OW5P/3sSji+XKlHy82FuXX2nwH9VHaas8GwMcFJ3mMHLBcBEzH4SbpQfvgNiTy2K8USyN3r/frU2WfrXLteD76hAWUgUMc1r7Y3/nasEa/kEeNgEpW0Y68RatRlD1ciLD+kH9IHhPo+nTdZOgZ9UhmTH1Vs=";
  gateHostED = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLGjd3NZt+wFUpZggqGr+9NPCoy2wloMWdkMq2LG10W";
  gate = [gateUserQ gateHostRSA gateHostED];
in {
  "q.age".publicKeys = gate;
  "share-bucket.age".publicKeys = gate;
}
