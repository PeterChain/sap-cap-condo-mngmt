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
            TypeName: '{i18n>Rent}',
            TypeNamePlural : '{i18n>Rents}',
            Title: { Value: ID },
            Description: { Value: '{i18n>RentContract}' },
        },

        Identification: [
            {Value: fraction.fraction},
            {Value: rentFrom},
            {Value: rentTo}
        ],

        Facets: [
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>RentValues}', Target: '@UI.FieldGroup#RentValues'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Others}', Target: '@UI.FieldGroup#Others'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Payments}', Target: 'payments/@UI.LineItem'},
        ],

        FieldGroup#RentValues: {
			Data: [
				{Value: monthlyRent},
				{Value: rentCurrency_code},
				{Value: paidPeriod}
			]
		},

        FieldGroup#Others: {
			Data: [
				{Value: tenant_ID},
				{Value: status_status }
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
