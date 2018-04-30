pragma solidity ^0.4.19;

contract InterfaceEmployeeStorage {

    function add(address _address, uint256 _monthlySalary, uint256 _startDate) public;
    function setAddress(address _address, address _newAddress) public;
    function setlatestPayday(address _address, uint256 _date) public;
    function setMonthlySalary(address _address, uint256 _salary) public;

    function getCount() public view returns(uint256);
    function getId(address _address) public view returns (uint256);
    function getAddress(uint256 _id) public view returns(address);
    function getLatestPayday(address _address) public view returns (uint256);
    function getMonthlySalary(address _address) public view returns(uint256);

    function remove(address _address) public;

}
