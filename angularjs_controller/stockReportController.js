app.controller("stockReportController", function ($scope,$http,$filter,$rootScope,$timeout,CommonCode) {
    $scope.msg = "This is Stock Report controller";
    
    $scope.tab = 1;

    $scope.setTab = function(newTab){
        $scope.tab = newTab;
    };


    $scope.isSet = function(tabNum){
        return $scope.tab === tabNum;
        if(newTab==1){
            $scope.isUpdateableOil=false;
        }
    };

    $scope.sort = {
        active: '',
        descending: undefined
    };

    $scope.changeDateFormat=function(userDate){
        return moment(userDate).format('YYYY-MM-DD');
    };

    $scope.selectedTab = {
        "color" : "white",
        "background-color" : "coral",
        "font-size" : "15px",
        "padding" : "5px"
    };


    $scope.changeSorting = function(column) {

        var sort = $scope.sort;

        if (sort.active == column) {
            sort.descending = !sort.descending;
        }
        else {
            sort.active = column;
            sort.descending = false;
        }
    };
    $scope.getIcon = function(column) {

        var sort = $scope.sort;

        if (sort.active == column) {
            return sort.descending
                ? 'glyphicon-chevron-up'
                : 'glyphicon-chevron-down';
        }

        return 'glyphicon-star';
    };



    $scope.loadAllReportByDateToDate=function(start_date,end_date){
        var start_date=$scope.changeDateFormat(start_date);
        var end_date=$scope.changeDateFormat(end_date);
        var request = $http({
            method: "post",
            url: site_url+"/Report/get_report_by_date",
            data: {
                start_date: start_date
                ,end_date: end_date
            }
            ,headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        }).then(function(response){
            $scope.reportList=response.data.records;
        });
    };//end of loadcustomers





    // $scope.$watch("mustardOilBillDetails", function(newValue, oldValue){
    //
    //     if(newValue != oldValue){
    //         var result=alasql('SELECT sum(gross_value) as totalGrossValue,sum(total_tax) as grandTotalTax,sum(total_amount) as grandTotalAmount  from ? ',[newValue]);
    //         $scope.mOilShowTableFooter=result[0];
    //         $scope.mOilShowTableFooter.finalBillTotal=$scope.mOilShowTableFooter.grandTotalAmount+$scope.oilMaster.roundedOff;
    //         var tempGstTable=alasql('SELECT hsn_code,gst_rate,max(cgst) as cgst_rate, max(sgst) as sgst_rate, max(igst) as igst_rate,sum(sgst_value) as sum_of_sgst,sum(cgst_value) as sum_of_cgst,sum(igst_value)as sum_of_igst,sum(taxable_amount) as sum_of_taxable_amount from ? group by hsn_code,gst_rate',[newValue]);
    //         $scope.gstTable=tempGstTable;
    //         var temp=alasql('SELECT SUM(sum_of_sgst) AS total_sgst,SUM(sum_of_cgst) AS total_cgst,SUM(sum_of_igst) AS total_igst from ?',[tempGstTable]);
    //         // console.log(temp[0]);
    //         $scope.gstTableFooter=temp[0];
    //         // console.log($scope.gstTableFooter);
    //     }
    // });



});

