using { pt.condo.rent as rent } from '../db/rent_schema';

// Rent and tenants administration
service RentManagement 
    @( path: '/rent' )
    // @( path: '/rent', requires: 'authenticated-user') 
{
    // @restrict: [
    //     { grant: 'READ', to: 'tenant' },
    //     { grant: ['CREATE','READ','UPDATE', 'DELETE'], to: 'admin' },
    // ]
    entity Tenant as projection on rent.Tenant 
        excluding {createdAt, createdBy, modifiedAt, modifiedBy};

    @capabilities: {
       Insertable:true, 
       Updatable:true,
       Deletable:false 
    }
    // @restrict: [
    //     { grant: 'READ', to: 'tenant' },
    //     { grant: ['READ', 'UPDATE','CREATE'], to: 'admin' },
    // ]
    entity Rent as projection on rent.Rent;
}