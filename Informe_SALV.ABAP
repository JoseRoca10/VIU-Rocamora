*&---------------------------------------------------------------------*
*& Report  ZALV_SAMPLE_CLASS
*&
*&---------------------------------------------------------------------*
REPORT  ZALV_SAMPLE_CLASS.

*******************************************************
**Types Declaration
*******************************************************

TYPES: BEGIN OF TY_CUST,
       CUSTID     TYPE ZCUST_MASTER4-CUSTID,
       CUSTNAME   TYPE ZCUST_MASTER4-CUSTNAME,
       ADDRESS    TYPE ZCUST_MASTER4-ADDRESS,
       CITY       TYPE ZCUST_MASTER4-CITY,
       STATE      TYPE ZCUST_MASTER4-STATE,
       COUNTRY    TYPE ZCUST_MASTER4-COUNTRY,
       PHNUM      TYPE ZCUST_MASTER4-PHNUM,
       EMAIL      TYPE ZCUST_MASTER4-EMAIL,
       FAX        TYPE ZCUST_MASTER4-FAX,
       STATUS     TYPE ZCUST_MASTER4-STATUS,
       LIGHTS(1)  TYPE C,
       END OF TY_CUST.
	   
*******************************************************
**Data Declaration
*******************************************************

DATA: ALV_CONTAINER  TYPE REF TO CL_GUI_DOCKING_CONTAINER.
DATA: ALV_GRID       TYPE REF TO CL_GUI_ALV_GRID.
DATA: LAYOUT    TYPE LVC_S_LAYO.
DATA: FIELDCAT  TYPE LVC_T_FCAT.
DATA: WT_CUST TYPE STANDARD TABLE OF TY_CUST,
      WA_CUST TYPE TY_CUST.
DATA: VARIANT TYPE  DISVARIANT.
DATA: REPID TYPE SY-REPID.  REPID = SY-REPID.
PARAMETERS: P_CHECK.

*******************************************************
**Initialization Declaration
*******************************************************

INITIALIZATION.

***To Get data from the database table
  PERFORM GET_DETAILS.
  VARIANT-REPORT = SY-REPID.
  VARIANT-USERNAME = SY-UNAME.
***Perform to design the layout
  PERFORM LAYOUT.
  
*********************************************************
**Create object alv container
*********************************************************

  CHECK ALV_CONTAINER IS INITIAL.
  CREATE OBJECT ALV_CONTAINER
    EXPORTING
      REPID                       = SY-REPID
      DYNNR                       = SY-DYNNR
      SIDE                        = ALV_CONTAINER->DOCK_AT_LEFT
      EXTENSION                   = 1550
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  
*********************************************************
**Create object alv Grid
*********************************************************

  CREATE OBJECT ALV_GRID
    EXPORTING
      I_PARENT = ALV_CONTAINER.
	  
***Perform to d3esign field catalog
  PERFORM FIELDCATATALOG.
  
*********************************************************
**Call method set table for first display
*********************************************************

  CALL METHOD ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'WT_CUST'
      IS_VARIANT                    = VARIANT
      I_SAVE                        = 'U'
      IS_LAYOUT                     = LAYOUT
    CHANGING
      IT_OUTTAB                     = WT_CUST
      IT_FIELDCATALOG               = FIELDCAT
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  
*******************************************************
**Start-of-selection Declaration
*******************************************************

START-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  GET_DETAILS
*&---------------------------------------------------------------------*
*       To get the data from th database table ZCUST_MASTER4
*----------------------------------------------------------------------*
FORM GET_DETAILS .

  SELECT * FROM ZCUST_MASTER4 INTO CORRESPONDING FIELDS OF TABLE WT_CUST.
  IF SY-SUBRC = 0.
    SORT WT_CUST ASCENDING  BY CUSTID.
  ENDIF.
  
ENDFORM.                    " GET_DETAILS
*&---------------------------------------------------------------------*
*&      Form  FIELDCATATALOG
*&---------------------------------------------------------------------*
*       Building Fieldcatlog for ALV
*----------------------------------------------------------------------*
FORM FIELDCATATALOG .
  DATA: LS_FCAT TYPE LVC_S_FCAT.
  REFRESH: FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Signal'.
  LS_FCAT-FIELDNAME  = 'LIGHTS'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '20'.
  LS_FCAT-COL_POS    = '1'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Customer Id'.
  LS_FCAT-FIELDNAME  = 'CUSTID'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '10'.
  LS_FCAT-FIX_COLUMN = 'X'.
  LS_FCAT-KEY        = 'X'.
  LS_FCAT-COL_POS    = '2'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'CustomerName '.
  LS_FCAT-FIELDNAME  = 'CUSTNAME'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '30'.
  LS_FCAT-FIX_COLUMN = 'X'.
  LS_FCAT-KEY        = 'X'.
  LS_FCAT-COL_POS    = '3'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Address'.
  LS_FCAT-FIELDNAME  = 'ADDRESS'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '40'.
  LS_FCAT-COL_POS    = '4'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'City'.
  LS_FCAT-FIELDNAME  = 'CITY'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '15'.
  LS_FCAT-COL_POS    = '5'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'State'.
  LS_FCAT-FIELDNAME  = 'STATE'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '15'.
  LS_FCAT-COL_POS    = '6'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Country'.
  LS_FCAT-FIELDNAME  = 'COUNTRY'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '15'.
  LS_FCAT-FIX_COLUMN = 'X'.
  LS_FCAT-KEY        = 'X'.
  LS_FCAT-COL_POS    = '7'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Phone number'.
  LS_FCAT-FIELDNAME  = 'PHNUM'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '14'.
  LS_FCAT-FIX_COLUMN = 'X'.
  LS_FCAT-KEY        = 'X'.
  LS_FCAT-COL_POS    = '8'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Email'.
  LS_FCAT-FIELDNAME  = 'EMAIL'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '50'.
  LS_FCAT-COL_POS    = '9'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Fax'.
  LS_FCAT-FIELDNAME  = 'FAX'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '15'.
  LS_FCAT-COL_POS    = '10'.
  APPEND LS_FCAT TO FIELDCAT.
  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Status'.
  LS_FCAT-FIELDNAME  = 'STATUS'.
  LS_FCAT-REF_TABLE  = 'WT_CUST'.
  LS_FCAT-OUTPUTLEN  = '20'.
  LS_FCAT-COL_POS    = '11'.
  APPEND LS_FCAT TO FIELDCAT.
ENDFORM.                    " FIELDCATATALOG

*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       Designing of ALV Layout
*----------------------------------------------------------------------*
FORM LAYOUT .
***If the customer's status is 'Inactive' the traffic signal will be 1 i.e, RED
***If the customer's status is 'Active'  the traffic signal will be 3 i.e, GREEN
  LOOP AT WT_CUST INTO WA_CUST.
    IF WA_CUST-STATUS = 'INACTIVE'.
      WA_CUST-LIGHTS  = '1'.
    ELSEIF WA_CUST-STATUS = 'ACTIVE'.
      WA_CUST-LIGHTS  = '3'.
    ENDIF.
    MODIFY WT_CUST FROM WA_CUST TRANSPORTING LIGHTS.
  ENDLOOP.
  LAYOUT-EXCP_FNAME = 'LIGHTS'.
ENDFORM.                    " LAYOUT