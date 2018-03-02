var payroll = artifacts.require("Payroll");

module.exports = function(deployer) {
  deployer.deploy(payroll);
}
