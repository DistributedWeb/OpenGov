module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    const DAO_Token = await deployments.get("DAO_token");
  
    await deploy("Governor", {
      from: deployer,
      args: [DAO_Token.address],
      log: true,
    });
  };