using { cuid, managed, Currency } from '@sap/cds/common';

namespace pt.condo.rent;


type RentStatus : Integer enum {
    ok = 1;             //Payment is in order
    overdue = 2;        //Payment overdue
    legal_action = 3;   //Legal action ongoing
}

// Information about a tenant
entity Tenant : cuid, managed {
    name : String(40);
    surname : String(40);
    mail : String(80);
    mobile : String(20);
}

// Rent information per fraction and a period in time
@cds.autoexpose
entity Rent : cuid {
    fraction : String(5) not null;
    tenant : Association to one Tenant;
    monthlyRent : Decimal(9,2);
    rentCurrency : Currency;
    rentingPeriod : Integer;
    paidPeriod : Integer;
    status : RentStatus;
    rentFrom : Date;        //The reason we have rentFrom is due to the fact from is a reserved word
    rentTo : Date;
}

// Payments performed under a rent period for a fraction
entity PaymentHistory : cuid {
    paymentDate : Date;
    payedAmount : Decimal(9,2);
    payedCurrency : Currency;
    rent : Association to one Rent;
}