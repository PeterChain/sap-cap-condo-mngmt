using { cuid, temporal, Currency } from '@sap/cds/common';

namespace pt.condo.rent;


type RentStatus : Integer enum {
    ok = 1;             //Payment is in order
    overdue = 2;        //Payment overdue
    legal_action = 3;   //Legal action under action
}

// Information about a tenant
entity Tenant : cuid {
    name : String(40);
    surname : String(40);
    mail : String(80);
    mobile : String(20);
}

// Rent information per fraction and a period in time
entity Rent : cuid, temporal {
    fraction : String(5) not null;
    tenant : Association to one Tenant;
    monthly_rent : Decimal(9,2);
    rent_currency : Currency;
    status : RentStatus;
}

// Payments performed under a rent period for a fraction
entity PaymentHistory : cuid {
    payment_date : Date;
    payed_amount : Decimal(9,2);
    payed_currency : Currency;
    rent : Association to one Rent;
}