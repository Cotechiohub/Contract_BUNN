// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract ERC20{
    // Define state variables
    uint256 public totalsupply;
    string public name;
    string public symbol;
    // uint8 public decimal;

    mapping(address => uint256) public balanceof;

    mapping(address=>mapping (address =>uint256))public allowance;

    event Transfer( address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed  spender, uint256 amount);

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;

        _mint(msg.sender, 600e18);

        _burn(msg.sender, 400e18);
}

    function decimal() public pure returns (uint8){
        return 18;
}
    
    //recipient: the person the caller wants to send token to
    function transferFrom(address recipient,uint256 amount) external returns (bool){
        return _transfer(msg.sender, recipient, amount);
}

function transferfrom(address sender, address recipient, uint256 amount) external returns (bool){

    uint256 currentBalance = allowance[sender][msg.sender];
    require(currentBalance >= amount, "Erc20 transfer amount must exceed allowance");

    allowance[sender][msg.sender]= currentBalance - amount;

    emit Approval(sender, recipient, amount);

    return _transfer(sender, recipient, amount);
}

    function appropve(address spender,uint256 amount) external returns (bool){

        require(spender != address(0), "erc20 approve to the address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true; 
}


function _transfer(address sender , address recipient, uint256 amount) private returns (bool){

    require(recipient != address(0), "erc20 transfer to address 0");

    uint256 senderBalance = balanceof[sender];

    require(senderBalance >= amount, "erc20 transfer amount exceeds balance");

    balanceof[sender] = senderBalance - amount;

    balanceof[recipient] += amount;

    emit Transfer(sender, recipient, amount);
    return true;
}


function _burn(address to, uint256 amount) internal {
    require(to != address(0), "erc20: burn from the 0 address");

    balanceof[to] += amount; 
    totalsupply += amount;
    emit Transfer(to, address(0), amount);
}

    function _mint(address to, uint256 amount) internal{
         require(to != address(0), "Erc20 mint to address 0");

        totalsupply += amount;
        balanceof[to] += amount;

  emit Transfer(address(0), to, amount);
   }

}
