module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
  
    await deploy("DAO_token", {
      from: deployer,
      args: ["DAO Token", "DAO"],
      log: true,
    });
  };