using { pt.condo.rent as rent } from '../db/schema';


service RentService @(path: '/rent') {
    @requires: 'authenticated-user'
    entity Tenant as projection on rent.Tenant;

    @requires: 'authenticated-user'
    @readonly
    entity Rent as projection on rent.Rent;
}