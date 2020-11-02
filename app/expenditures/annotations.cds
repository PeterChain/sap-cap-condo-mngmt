using RentManagement as service from '../../srv/rent';

annotate service.Expenditures with @(
    UI: {
		LineItem: [
            {Value: rent.fraction.fraction},
            {Value: rent.tenant.name},
            {Value: rent.tenant.surname},
            {Value: expenditureType.name},
            {Value: rentYear},
            {Value: rentMonth},
            {Value: payed},
        ],

        HeaderInfo: {
            TypeName: '{i18n>Expenditure}', TypeNamePlural: '{i18n>Expenditures}',
			Title: {
				Value: ID
			},
			Description: {Value: rent.ID}
        },

        Identification: [
			{Value: expenditureType.name},
			{Value: rent.tenant.name },
			{Value: rent.tenant.surname},
			{Value: date},
		],

        Facets: [
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Expense}', Target: '@UI.FieldGroup#Expense'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Monthly}', Target: '@UI.FieldGroup#Monthly'},
        ],

        FieldGroup#Expense: {
			Data: [
				{Value: detail},
				{Value: amount},
				{Value: currency_code}
			]
		},

        FieldGroup#Monthly: {
			Data: [
				{Value: rentMonth},
				{Value: rentYear}
			]
		}
    }
);