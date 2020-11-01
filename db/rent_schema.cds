using { cuid, managed, Currency, sap.common.CodeList as CodeList } from '@sap/cds/common';

namespace pt.condo.rent;

type RentStatusCode : Integer enum {
    ok = 1;             //Payment is in order
    overdue = 2;        //Payment overdue
    legal_action = 3;   //Legal action ongoing
}

type ExpenditureType : Association to ExpenditureTypes;

entity ExpenditureTypes: CodeList {
    key code: String(1)
}

entity RentingStatus {
    key status: RentStatusCode;
    description: localized String;
}

entity Fractions {
    key fraction: String(5);
    area: Integer;
    floor: Integer;
}

entity Tenant : cuid, managed {
    tenantKey: String(25);
    name : String(40);
    surname : String(40);
    mail : String(80);
    mobile : String(20);
    taxNumber : String(20);
    rents: Composition of many Rent on rents.tenant = $self;
}

entity Rent : cuid {
    fraction : Association to one Fractions not null;
    tenant : Association to one Tenant;
    monthlyRent : Decimal(9,2);
    rentCurrency : Currency;
    rentingPeriod : Integer;
    paidPeriod : Integer;
    status : Association to one RentingStatus;
    rentFrom : Date;        //The reason we have rentFrom is due to the fact from is a reserved word
    rentTo : Date;
    expenditures: Composition of many Expenditures on expenditures.rent = $self;
}

entity Expenditures : cuid {
    rent: Association to one Rent;
    detail : String(100);
    amount : Decimal(9,2);
    currency : Currency;
    payed : Boolean;
    date : Date;
    rentYear: Integer;
    rentMonth: Integer;
    expenditureType: ExpenditureType;
}

annotate RentingStatus with @( cds.odata.valuelist );
annotate Fractions with @( cds.odata.valuelist );
annotate Tenant with @( cds.odata.valuelist );
annotate ExpenditureTypes with @( cds.odata.valuelist );

annotate ExpenditureType with {
    rent        @title: '{i18n>expTypeRent}';
    additionals @title: '{i18n>expTypeAdds}';
};


annotate Tenant with {
    ID          @readonly;
    name        @title: '{i18n>tenantName}';
    surname     @title: '{i18n>tenantSurname}';
    mail        @title: '{i18n>tenantMail}';
    mobile      @title: '{i18n>tenantMobile}';
    taxNumber   @title: '{i18n>tenantTaxnNum}';
    tenantKey   @title: '{i18n>tenantID}'
                @readonly;
}

annotate Rent with {
    ID              @title: '{i18n>rentID}'
                    @readonly;
    fraction        @title: '{i18n>rentFraction}';
    tenant          @title: '{i18n>rentTenant}';
    monthlyRent     @title: '{i18n>rentMonthlyRent}';
    rentCurrency    @title: '{i18n>rentCurrency}';
    rentingPeriod   @title: '{i18n>rentRentingPeriod}';
    paidPeriod      @title: '{i18n>rentPaidPeriod}';
    status          @title: '{i18n>rentStatus}';
    rentFrom        @title: '{i18n>rentRentFrom}';
    rentTo          @title: '{i18n>rentRentTo}';
    tenant_ID       @ValueList.entity: Tenant;
};

annotate Expenditures with {
    detail          @title: '{i18n>expDetail}';
    date            @title: '{i18n>expDate}';
    amount          @title: '{i18n>expAmount}';
    currency        @title: '{i18n>expCurrency}';
    payed           @title: '{i18n>expPayed}';
    rent            @title: '{i18n>expRent}';
    rentYear        @title: '{i18n>expRentYear}';
    rentMonth       @title: '{i18n>expRentMonth}';
    expenditureType @title: '{i18n>expRentType}';
}

annotate RentingStatus with {
    status      @title: '{i18n>statusCode}';
    description @title: '{i18n>statusDescription}';
};

annotate Fractions with {
    fraction    @title: '{i18n>fractionID}';
    area        @title: '{i18n>fractionArea}';
    floor       @title: '{i18n>fractionFloor}';
};

define view RentExpenditures as select from Expenditures {
    ID,
    detail,
    expenditureType,
    amount,
    rentYear,
    rentMonth,
    payed,
    rent
};

define view TenantRents as select from Rent 
    excluding { monthlyRent, 
                rentCurrency, 
                rentingPeriod,
                expenditures };