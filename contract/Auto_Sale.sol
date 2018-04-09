pragma solidity ^0.4.21;

contract Automobile_Sale{

    // attributes of toyota japan
    string  private mName;
    address private mAddress;
    uint[]  private assetOwnedByManufacture;
    string  private manufacturing_origin;
    
    // attributes of Car
    struct Cars{
        uint      lot_Number;
        string    color;
        string    EngineType;
        string    date_of_manufacturing;
        string    geolocation;
        string    currentOwner;
        bool      initialized;
        string[]  previousOwners;
        string[]  previousOwnersLocation;
    }
    // maps the values of Cars to reference it wiht Car   
    mapping(uint => Cars) public Car;
    
    
    // attributes of the distributor/owners that will buy of Toyota
    struct owners{
        string name;
        string geolocation;
        uint[] CurrentOwnedAssetsByOwner;
    }
    // maps the values of Owners to reference it wiht Owner
    mapping (address => owners) public owner;
    ////////////////////////////////////////////////////////////////////////////

    // functions     
    function Automobile_Sale() public payable{
        mName = "Toyota Japan";
        mAddress = msg.sender;
        manufacturing_origin = "Japan";
    }
    
    ////////////////////////////////////////////////////////////////////////////    
    // events for asset creation or deletion
    event AssetCreate(address account, uint VIN, string message);
    event RejectCreate(address account, uint VIN, string message);    

    function createAsset (uint _VIN,string _color, string _EngineType, string _geolocation, string _date) onlyCanBeCalledByManufacturer public payable {
        // Here 10 cars will be created by
        // Toyota japan as an asset
        if(!Car[_VIN].initialized)
        {
            Car[_VIN].initialized = true;               // initializes the existence of asset
            Car[_VIN].currentOwner = "Toyota";          // initializes the name of the manufacturer
            Car[_VIN].lot_Number = 1;                   // initializes the lot number of car
            Car[_VIN].color = _color;                   // initializes the color of car
            Car[_VIN].EngineType = _EngineType;         // initializes the engine type to petrol or deisel
            Car[_VIN].date_of_manufacturing = _date;    // initializes the manufacturing date
            Car[_VIN].geolocation = _geolocation;       // initializes the geolocation of the car
            assetOwnedByManufacture.push(_VIN);         // pushes to the stack of ownership that manufacturer have
            emit AssetCreate(msg.sender, _VIN, "Asset created!");
        }
        else{
            emit RejectCreate(msg.sender, _VIN, "Asset Already exist!");  
        }
    }
    
    // sets the event if asset being called does not exist
    event AssetDoesNotExist(string message);
    // gets specific VIN numbered car
    function getSpecificCar(uint _vinNumber) public view returns (uint, string, string, string,string) {
        if(!Car[_vinNumber].initialized){
            return  (Car[_vinNumber].lot_Number,Car[_vinNumber].color,Car[_vinNumber].EngineType,Car[_vinNumber].date_of_manufacturing,Car[_vinNumber].geolocation);
        } else{
            emit AssetDoesNotExist("Asset deos not exist ");
            
        }
    }

    // gets the list of #VIN of Cars owned by manufacturer
    function getListOfAssetsOwnedByManufacturer() public view returns (uint[]) {
        return assetOwnedByManufacture;
    }

    // gets the current owner of the asset
    function getCurrentOwnerOfAsset(uint _VIN) public view returns (string, string) {
        return (Car[_VIN].currentOwner, Car[_VIN].geolocation);
        
    }

    // gets the two previous owners and their location
    function getPreviousOwnerOfAsset(uint _VIN) public view returns (string, string, string,  string) {
        return (Car[_VIN].previousOwners[Car[_VIN].previousOwners.length - 1], Car[_VIN].previousOwnersLocation[Car[_VIN].previousOwnersLocation.length - 1], Car[_VIN].previousOwners[Car[_VIN].previousOwners.length - 2], Car[_VIN].previousOwnersLocation[Car[_VIN].previousOwnersLocation.length - 2]);
    }


    // Function for the transfer of ether in exchange of the Asset
    function transferEther(address _EtherReciever, address _EtherSender) private{
        _EtherReciever.transfer(msg.value);
        // to.transfer(amount);
    }

    // events that triggers on successful transfer of onwnership
    event AcceptOwnership(address ownerAdd, string message);
    event RejectOwnership(address ownerAdd, string message);

    // it transfers the ownership of the asset in exchange of money    
    function transferToOwner(address _AssetReciever, string _NewOwnerName, uint _VIN, string _geolocation) requiredAmount public payable{
        if(Car[_VIN].initialized){
            owner[_AssetReciever].CurrentOwnedAssetsByOwner.push(_VIN);
            owner[_AssetReciever].name           = _NewOwnerName;
            owner[_AssetReciever].geolocation    = _geolocation;
            Car[_VIN].previousOwners.push(Car[_VIN].currentOwner);
            Car[_VIN].previousOwnersLocation.push(Car[_VIN].geolocation); 
            Car[_VIN].currentOwner   = _NewOwnerName;
            Car[_VIN].geolocation    = _geolocation;
            
            //transfers ether for Asset Exchange
            transferEther(msg.sender, _AssetReciever);
            // Event is triggered in exchange of ownership
            emit AcceptOwnership(msg.sender, "Assset Transfered");
        }else{
            // ownership is rejected if asset does not exist
            emit RejectOwnership(msg.sender, "Asset does not exist");
        }
    }
    

    
    modifier requiredAmount{
        require(msg.value == 1 ether);
        _;
    }
    modifier onlyCanBeCalledByManufacturer {
        require(msg.sender == mAddress);
        _;
    }
}