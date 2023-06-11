module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    const Governor = await deployments.get("Governor");
  
    const gnosisSafeAdapter = await deploy("GnosisSafeAdapter", {
      from: deployer,
      log: true,
    });
    const aragonAdapter = await deploy("AragonAdapter", {
      from: deployer,
      log: true,
    });
    const daostackAdapter = await deploy("DAOstackAdapter", {
      from: deployer,
      log: true,
    });
    const molochAdapter = await deploy("MolochAdapter", {
      from: deployer,
      log: true,
    });
  
    const governor = await ethers.getContractAt("Governor", Governor.address);
    await governor.setGnosisSafeAdapter(gnosisSafeAdapter.address);
    await governor.setAragonAdapter(aragonAdapter.address);
    await governor.setDAOstackAdapter(daostackAdapter.address);
    await governor.setMolochAdapter(molochAdapter.address);
  };