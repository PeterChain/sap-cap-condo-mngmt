using { pt.condo.rent as rent } from '../db/schema';

// Service for administrator
service RentAdminService @(path: '/rent') {
    // @requires: 'authenticated-user'
    entity Tenant as projection on rent.Tenant
        excluding {createdAt, createdBy, modifiedAt, modifiedBy};

    // @requires: 'authenticated-user'
    @capabilities: {
       Insertable:true, 
       Updatable:true,
       Deletable:false 
    }
    entity Rent as projection on rent.Rent;
}