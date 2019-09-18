pragma solidity ^0.5.0;
contract MoneyManagement{
    mapping (string=>address payable) accounts;
    mapping(address=>uint256) percentage;
    string[] names;
    uint remaning=100;
    
    function () payable external{
        emit PaymentReceived(msg.sender, msg.value);
        uint namesLength=names.length;
        for(uint i=0;i<namesLength;i++){
            address payable acc=accounts[names[i]];
            uint amount= msg.value*percentage[acc]/100;
            acc.transfer(amount);
            emit PaymentReceived(acc, amount);
        }
    }
    event PaymentReceived(address from, uint amount);
    function addAccount(address acc,string memory name,uint per )public returns(string memory s,uint p){
        require(per>0&&per<=remaning);
        accounts[name]=address(uint160(acc));
        percentage[acc]=per;
        remaning-=per;
        names.push(name);
        s=name;
        p=per;
        return(s,p);
    }
    function editPercentage(string memory name,uint256 per)public returns(uint256){
        require(accounts[name]!=address(0));
        remaning+=percentage[accounts[name]];
        require(per>0&&per<remaning);
        percentage[accounts[name]]=per;
        remaning-=per;
        return per;
    }
    function deleteAccount(string memory name)public{
        uint per=percentage[accounts[name]];
        remaning+=per;
        delete percentage[accounts[name]];
        delete accounts[name];
        uint i;
        for(i=0;i<names.length;i++){
            if(stringsEqual(names[i],name)){
                break;
            }
        }
        if(i<names.length-1){
            names[i]=names[names.length-1];
        }
        delete names[names.length-1];
        names.length--;
    }
    function editName(string memory preName,string memory newName)public returns(string memory){
        uint i;
        uint namesLength=names.length;
        for(i=0;i<namesLength;i++){
            if(stringsEqual(names[i],preName)){
                break;
            }
        }
        if(i<namesLength){
            names[i]=newName;
            accounts[newName]=accounts[preName];
            delete accounts[preName];
            return names[i];
        }
        else{
            return "Account with provided name not found";
        }
    }
    function getNames(uint i)public view returns(string memory){
    	require(i>0&&i<=names.length);
    	return names[i-1];
    }
    function getDetails(uint i)public view returns(string memory,address,uint){
        require(i>0&&i<=names.length);
        return (names[i-1],accounts[names[i-1]],percentage[accounts[names[i-1]]]);
    }
    function stringsEqual(string storage _a, string memory _b) view internal returns (bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (a.length != b.length)
        return false;
        for (uint i = 0; i < a.length; i ++)
            if (a[i] != b[i])
                return false;
            return true;
    }
}
