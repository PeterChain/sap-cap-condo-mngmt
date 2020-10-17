using RentManagement as service from '../../srv/rent';

annotate service.Rent with @(
    UI: {
        LineItem: [
            {Value: fraction.fraction},
            {Value: paidPeriod},
            {Value: monthlyRent},
            {Value: rentFrom},
            {Value: rentTo},
            {Value: status.description}
        ],

        HeaderInfo  : {
            $Type : 'UI.HeaderInfoType',
            TypeName : '{i18n>rent}',
            TypeNamePlural : '{i18n>rents}',
        },

        Identification: [
            {Value: fraction.fraction},
            {Value: rentFrom},
            {Value: rentTo}
        ],

        Facets: [
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>RentValues}', Target: '@UI.FieldGroup#RentValues'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Tenant}', Target: '@UI.FieldGroup#Tenant'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Payments}', Target: 'payments/@UI.LineItem'},
        ],

        FieldGroup#RentValues: {
			Data: [
				{Value: monthlyRent},
				{Value: rentCurrency_code},
				{Value: paidPeriod}
			]
		},

        FieldGroup#Tenant: {
			Data: [
				{Value: tenant.name},
				{Value: tenant.surname}
			]
		}
        
    }
);

annotate service.PaymentHistory with @(
    UI: {
        LineItem: [
            {Value: paymentDate},
            {Value: payedAmount},
            {Value: expense_ID},
            {Value: invoice_ID},
        ]
    }
);
