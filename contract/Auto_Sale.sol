pragma solidity ^0.4.21;

contract Automobile_Sale{

    // attributes of toyota japan
    string   mName;
    address  mAddress;
    uint[]   assetOwnedByManufacture;
    string   manufacturing_origin;
    
    // attributes of Car
    struct Cars{
        uint      lot_Number;
        string    color;
        string    EngineType;
        string    date_of_manufacturing;
        string    geolocation;
        string    currentOwner;
        bool      initialized;
    }
    // maps the values of Cars to reference it wiht Car   
    
    // attributes of the distributor/owners that will buy of Toyota
    struct owners{
        string name;
        string geolocation;
        mapping(uint => Cars)Car;
    }
    
    // maps the values of Owners to reference it wiht Owner
    mapping (address => owners) public owner;
    ////////////////////////////////////////////////////////////////////////////

    struct AssetTransferDetails{
        string  currentOwner;
        address currentOwnerAddress;
        string currentLocation;
        string[] previousOwner;
        string[] previousOwnersLocation;
    }
    
    mapping (uint => AssetTransferDetails) details;
    // functions     
    function Automobile_Sale(string _mName, string _origin) public payable{
        mName = _mName;
        mAddress = msg.sender;
        manufacturing_origin = _origin;
    }
    function getManufacturerName() public view returns(string, string){
        return (mName, manufacturing_origin);
    }
    ////////////////////////////////////////////////////////////////////////////    
    // events for asset creation or deletion
    event AssetCreate(address account, uint VIN, string message);
    event RejectCreate(address account, uint VIN, string message);    

    function createAsset (uint _VIN,string _color, string _EngineType, string _geolocation, string _date) public payable {
        // Here 10 cars will be created by
        // Toyota japan as an asset
        getSpecificCar(_VIN);
        if(!owner[mAddress].Car[_VIN].initialized)
        {
            owner[mAddress].Car[_VIN].initialized = true;               // initializes the existence of asset
            owner[mAddress].Car[_VIN].currentOwner = "Toyota";          // initializes the name of the manufacturer
            owner[mAddress].Car[_VIN].lot_Number = 1;                   // initializes the lot number of car
            owner[mAddress].Car[_VIN].color = _color;                   // initializes the color of car
            owner[mAddress].Car[_VIN].EngineType = _EngineType;         // initializes the engine type to petrol or deisel
            owner[mAddress].Car[_VIN].date_of_manufacturing = _date;    // initializes the manufacturing date
            owner[mAddress].Car[_VIN].geolocation = _geolocation;       // initializes the geolocation of the car
    
            details[_VIN].currentOwner = "Toyota Japan";
            details[_VIN].currentOwnerAddress = msg.sender;
            details[_VIN].currentLocation = "Tokyo, Japan";
    
            assetOwnedByManufacture.push(_VIN);         // pushes to the stack of ownership that manufacturer have
            emit AssetCreate(msg.sender, _VIN, "Asset created!");
        }
        else{
            emit RejectCreate(msg.sender, _VIN, "Asset Already exist!");  
        }
    }
    
    // sets the event if asset being called does not exist
    event AssetDoesNotExist(string message);
    // // gets specific VIN numbered car
    function getSpecificCar(uint _vinNumber) public view returns (uint, string, string, string,string) {
        if(owner[mAddress].Car[_vinNumber].initialized){
            return  (
                owner[mAddress].Car[_vinNumber].lot_Number, 
                owner[mAddress].Car[_vinNumber].color, 
                owner[mAddress].Car[_vinNumber].EngineType, 
                owner[mAddress].Car[_vinNumber].date_of_manufacturing, 
                owner[mAddress].Car[_vinNumber].geolocation);
        } else{
            emit AssetDoesNotExist("Asset deos not exist ");
            
        }
    }

    // // gets the list of #VIN of Cars owned by manufacturer
    function getListOfAssetsOwnedByManufacturer() public view returns (uint[]) {
        return assetOwnedByManufacture;
    }

    // // gets the current owner of the asset
    function getCurrentOwnerOfAsset(uint _VIN) public view returns (string, string) {
        return (details[_VIN].currentOwner, details[_VIN].currentLocation);
        
    }

    // event NoPreviousOwner(string msg);
    // // gets the two previous owners and their location
    function getPreviousOwnerOfAsset(uint _VIN) public view returns (string, string, string,  string) {
        return (
            details[_VIN].previousOwner[details[_VIN].previousOwner.length - 1], 
            details[_VIN].previousOwnersLocation[details[_VIN].previousOwnersLocation.length - 1],
            details[_VIN].previousOwner[details[_VIN].previousOwner.length - 2],
            details[_VIN].previousOwnersLocation[details[_VIN].previousOwnersLocation.length - 2]);
    }


    // Function for the transfer of ether in exchange of the Asset
    function transferEther(address _EtherReciever, address _EtherSender) private {
        _EtherReciever.transfer(msg.value);

    }

    // // events that triggers on successful transfer of onwnership
    event AcceptOwnership(address ownerAdd, string message);
    event RejectOwnership(address ownerAdd, string message);

    // // it transfers the ownership of the asset in exchange of money    
    function transferToOwner(address _AssetSender,address _AssetReciever, string _NewOwnerName, uint _VIN, string _geolocation)  public payable{
        if(owner[_AssetSender].Car[_VIN].initialized){
            owner[_AssetReciever].name           = _NewOwnerName;
            owner[_AssetReciever].geolocation    = _geolocation;

            details[_VIN].currentOwner   = _NewOwnerName;
            details[_VIN].currentLocation    = _geolocation;
            details[_VIN].previousOwner.push(details[_VIN].currentOwner);
            details[_VIN].previousOwnersLocation.push(details[_VIN].currentLocation); 
            
            //transfers ether for Asset Exchange
            transferEther(msg.sender, _AssetReciever);
            // Event is triggered in exchange of ownership
            emit AcceptOwnership(msg.sender, "Assset Transfered");
        } else{
            // ownership is rejected if asset does not exist
            emit RejectOwnership(msg.sender, "Asset does not exist");
        }
    }
    

    
    // modifier requiredAmount{
    //     require(msg.value == 1 ether);
    //     _;
    // }
    // modifier onlyCanBeCalledByManufacturer {
    //     require(msg.sender == mAddress);
    //     _;
    // }
 
}