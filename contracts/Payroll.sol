pragma solidity 0.4.19;

/// @title Payroll contract - Manage employees and token payments
/// @author Nicolas frega - <nicolas.frega@srax.com>

import './InterfacePayroll.sol';
import './EmployeeStorage.sol';
import './EmployeeToken.sol';

contract Payroll is InterfacePayroll, Ownable {
    using SafeMath for uint256;

    /*
     *  Events
     */
    event Deposit(address indexed sender, uint value);
    event NewEmployee(address indexed newEmployee);
    event EmployeeAddressChange(address indexed newAddress);
    event EmployeePaydayChange(address indexed employeeAddress, uint indexed newPayday);
    event EmployeeSalaryChange(address indexed employeeAddress, uint indexed newSalary);
    event EmployeeRemoved(address indexed employeeAddress, uint indexed_id);
    event EmployeePayed(address indexed employeeAddress, uint payPeriod);

    /*
     *  Storage
     */
    InterfaceEmployeeStorage public employeeStorage;
    EmployeeToken public employeeToken;

    /*
    * Modifiers
    */
    modifier validAddress(address _address) {
        require (_address != 0x0);
        _;
    }

    modifier higherThanZero(uint256 _uint) {
        require(_uint > 0);
        _;
    }

    modifier employeePayPeriodExists(uint256 _payPeriod) {
        require(_payPeriod == employeeStorage.getLatestPayday(msg.sender));
        _;
    }

    modifier enoughTokensLeft() {
        uint256 tokensLeft = employeeToken.balanceOf(employeeToken.owner());
        require(employeeStorage.getMonthlySalary(msg.sender) < tokensLeft);
        _;
    }

    /// @dev Fallback function allows to deposit ether.
    function()
        public
        payable
    {
        if (msg.value > 0)
            Deposit(msg.sender, msg.value);
    }

     /*
      * Public functions
      */
    /// @dev Contract constructor sets employee storage and employee token.
    function Payroll()
        public
    {
        setEmployeeStorage(new EmployeeStorage());
        setEmployeeToken(new EmployeeToken());
    }

    /// @dev adds a new employee.
    /// @param _address Address of new employee.
    /// @param _monthlySalary uint of salary.
    /// @param _startDate uint of starting date.
    function addEmployee(address _address, uint256 _monthlySalary, uint256 _startDate)
        public
        onlyOwner
        validAddress(_address)
        higherThanZero(_monthlySalary)
    {
        employeeStorage.add(_address, _monthlySalary, _startDate);
        NewEmployee(_address);
    }

    /// @dev changes the address of an existing employee.
    /// @param _id uint of existing employee id.
    /// @param _address Address of employee.
    function setEmployeeAddress(uint256 _id, address _address)
        public
        onlyOwner
        validAddress(_address)
    {
        address employeeAddress = employeeStorage.getAddress(_id);
        employeeStorage.setAddress(employeeAddress, _address);
        EmployeeAddressChange(employeeAddress);
    }

    /// @dev changes the payday of an existing employee.
    /// @param _address Address of employee.
    /// @param _date uint of new pay day.
    function setEmployeePayday(address _address, uint256 _date)
        public
        onlyOwner
        validAddress(_address)
    {
        employeeStorage.setlatestPayday(_address, _date);
        EmployeePaydayChange(_address, _date);
    }

    /// @dev changes the salary of an existing employee.
    /// @param _id uint of existing employee id.
    /// @param _monthlySalary uint of new pay day.
    function setEmployeeSalary(uint256 _id, uint256 _monthlySalary)
        public
        onlyOwner
        higherThanZero(_monthlySalary)
    {
        address employeeAddress = employeeStorage.getAddress(_id);
        employeeStorage.setMonthlySalary(employeeAddress, _monthlySalary);
        EmployeeSalaryChange(employeeAddress, _monthlySalary);

    }

    /// @dev gets the total employee count.
    /// @return Returns employee count.
    function getEmployeeCount()
        public
        onlyOwner
        constant
        returns (uint256)
    {
        return employeeStorage.getCount();
    }

    /// @dev gets the employee ID.
    /// @param _address Address of existing employee.
    /// @return Returns employee ID.
    function getEmployeeID(address _address)
        public
        onlyOwner
        validAddress(_address)
        constant
        returns (uint256)
    {
        return employeeStorage.getId(_address);
    }

    /// @dev gets the total employee address from ID.
    /// @param _id ID of existing employee.
    /// @return Returns employee address.
    function getEmployeeAddress(uint256 _id)
        public
        onlyOwner
        constant
        returns (address)
    {
        return employeeStorage.getAddress(_id);
    }

    /// @dev gets the latest employee pay day.
    /// @param _address Address of existing employee.
    /// @return Returns employee pay day.
    function getEmployeePayday(address _address)
        public
        onlyOwner
        validAddress(_address)
        constant
        returns (uint256)
    {
        return employeeStorage.getLatestPayday(_address);
    }

    /// @dev gets the employee salary.
    /// @param _address Address of existing employee.
    /// @return Returns employee salary.
    function getEmployeeSalary(address _address)
        public
        onlyOwner
        validAddress(_address)
        constant
        returns (uint256)
    {
        return employeeStorage.getMonthlySalary(_address);
    }

    /// @dev gets the total employee info.
    /// @param _id ID of existing employee.
    /// @return Returns all existing employee info.
    function getEmployee(uint256 _id)
        public
        onlyOwner
        constant
        returns (address _address, uint256 _payday, uint256 _salary, uint256 _payed)
    {
        _address = employeeStorage.getAddress(_id);
        _payday = employeeStorage.getLatestPayday(employeeStorage.getAddress(_id));
        _salary = employeeStorage.getMonthlySalary(employeeStorage.getAddress(_id));
        _payed = employeeToken.balanceOf(_address);
    }

    /// @dev gets the balance of employee.
    /// @param _id ID of existing employee.
    /// @return Returns employee balance.
    function getEmployeeBalance(uint256 _id)
        public
        onlyOwner
        constant
        returns (uint256)
    {
        address employeeAddress = employeeStorage.getAddress(_id);
        return employeeToken.balanceOf(employeeAddress);
    }

    /// @dev gets the balance left of employee tokens.
    /// @return Returns the token balance.
    function getTotalSupply()
        public
        onlyOwner
        constant
        returns (uint256)
    {
        return employeeToken.totalSupply();
    }

    /// @dev removes and employee.
    /// @param _id ID of existing employee.
    function removeEmployee(uint256 _id)
        public
        onlyOwner
    {
        address employeeAddress = employeeStorage.getAddress(_id);
        employeeStorage.remove(employeeAddress);
        EmployeeRemoved(employeeAddress, _id);
    }

    /// @dev allows employee to get payed.
    /// @param _payPeriod of requested payment.
    function getPay (uint256 _payPeriod)
        public
        employeePayPeriodExists(_payPeriod)
        enoughTokensLeft()
    {
        uint256 employeeSalary = employeeStorage.getMonthlySalary(msg.sender);
        employeeToken.transfer(msg.sender, employeeSalary);

        uint256 newPayday = employeeStorage.getLatestPayday(msg.sender);
        newPayday++;
        employeeStorage.setlatestPayday(msg.sender, newPayday);
        EmployeePayed(msg.sender, newPayday--);

    }

    /*
     * Internal functions
     */
     /// @dev sets the employee storage contract.
     /// @param _newEmployeeStorage Address of new employee storage.
     function setEmployeeStorage(address _newEmployeeStorage)
         internal
         onlyOwner
         validAddress(_newEmployeeStorage)
     {
         employeeStorage = InterfaceEmployeeStorage(_newEmployeeStorage);
     }

     /// @dev sets the employee token contract.
     /// @param _newEmployeetoken Address of new employee token.
     function setEmployeeToken(address _newEmployeetoken)
         internal
         onlyOwner
         validAddress(_newEmployeetoken)
     {
         employeeToken = EmployeeToken(_newEmployeetoken);
     }

}
