<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class StockReport extends CI_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('session');
        $this -> load -> model('person');
        $this -> load -> model('report_model');
        //$this -> is_logged_in();
    }
    function is_logged_in() {
		$is_logged_in = $this -> session -> userdata('is_logged_in');
		if (!isset($is_logged_in) || $is_logged_in != 1) {
			echo 'you have no permission to use developer area'. '<a href="">Login</a>';
			die();
		}
	}
    function get_products(){
        $result=$this->sale_model->select_inforce_products()->result_array();
        $report_array['records']=$result;
        echo json_encode($report_array);
    }


    public function angular_view_report(){
        ?>
        <style type="text/css">
            .td-input{
                padding: 2px;
                margin-left: 0px;
                margin-right: 0px;
                text-align: right;
            }
            #sale-table th, #sale-table tr td{
                border: 0;
                padding: 0px;
            }
            #sale-table tfoot{
                border-top: 1px solid black;
            }
            .form-control{
                padding: 0 !important;
            }
            .btn{
                padding-top: 0px !important;
                padding-bottom: 0px !important;
                padding-left: 3px !important;
                padding-right: 3px !important;
            }
            .highlightOne {
                background: orange;
                font-size: 125%;
                margin: 5px;
                padding: 5px;
            }
            .report-table tr th,.report-table tr td{
                border: 1px solid black !important;
                font-size: 12px;
                line-height: 0px;
            }
           

        </style>
        <!--  Start of Navigation Bar -->
        <div class="d-flex">
            <div class="p-2 my-flex-item col-12">
            <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
                    <!-- Brand -->
                    <a class="navbar-brand" href="#">Logo</a>

                    <!-- Links -->
                    <ul class="navbar-nav">
<!--                        <li class="nav-item">-->
<!--                            <a class="nav-link" href="#">Link 1</a>-->
<!--                        </li>-->

                        <!-- Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
                                Master
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#!studentMaster"><i class="fas fa-user-graduate"></i> Vendor</a>
                                <a class="dropdown-item" href="#!studentMaster"><i class="fas fa-user-graduate"></i> Customer</a>
                                <a class="dropdown-item" href="#!product">Product</a>
                            </div>
                        </li>
                        <!-- Transaction -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
                                Transaction
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#!purchase"><i class="fas fa-shopping-cart "></i>Purchase</a>
                                <a class="dropdown-item" href="#!production"><i class="fas fa-exchange-alt "></i>Production</a>
                                <a class="dropdown-item" href="#!sale"><i class="fas fa-balance-scale"></i>Sale</a>
                            </div>
                        </li>

                        <!-- Report -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
                                Report
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#!salereport"><i class="fas fa-shopping-cart "></i>Sale Report</a>
                                <a class="dropdown-item" href="#!stockreport"><i class="fas fa-exchange-alt "></i>Stock Report</a>
                            </div>
                        </li>

                    </ul>
                </nav>
            </div>

        </div>      <!--  End of Navigation Bar -->

        <div class="d-flex col-12">
            <div class="col-12">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs nav-justified indigo" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" ng-style="tab==1 && selectedTab" href="#" role="tab" ng-click="setTab(1)"><i class="fas fa-user-graduate"></i></i>Mseed Stock</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" ng-style="tab==2 && selectedTab" href="#" role="tab" ng-click="setTab(2)"><i class="fa fa-envelope"></i>MOil Stock </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" ng-style="tab==2 && selectedTab" href="#" role="tab" ng-click="setTab(3)"><i class="fa fa-envelope"></i>Oil Cake Stock </a>
                    </li>

                </ul>
                <!-- Tab panels -->
                <div class="tab-content">
                    <!--Panel 1-->
                    <div ng-show="isSet(1)">
                        <div id="row my-tab-1">
                            <form name="saleForm" class="form-horizontal" id="saleForm">
                                <div class="" id="sale-master-card">
                                    <div class="d-flex pt-0 pb-0 bg-gray-2">
                                        <div class="d-flex">
                                            <div class="col"><input type="date" class="form-control" ng-model="start_date"></div>
                                            <div class="col ml-1 mr-1">TO</div>
                                            <div class="col"><input type="date" class="form-control" ng-model="end_date"></div>
                                            <div class="col ml-1"><input type="button" class="form-control" value="Submit" ng-click="loadAllReportByDateToDate(start_date,end_date)"></div>
                                        </div>
                                    </div>

                                    <div class="d-flex">
                                    <div class="offset-1 pt-2">
                                    <table class="table table-bordered table-responsive report-table" id="stock-reprt-table">
                                            <thead>
                                           
                                            <tr>
                                                <th>Date</th>
                                                <th>Op.Stock</th>
                                                <th colspan="6" class="text-center bg-warning">Purchase(If any)</th>
                                                <th>Total</th>
                                                <th>Mseed.for.production</th>
                                                <th>Produced.Moil</th>
                                                <th>Produced.Oilcake</th>
                                                <th>Clos.Stock</th>
                                            </tr>
                                            <tr>
                                                <th></th>
                                                <th></th>
                                                <th>Vendor</th>
                                                <th>GSTNo</th>
                                                <th>Total amt</th>
                                                <th>SGST</th>
                                                <th>CGST</th>
                                                <th>IGST</th>
                                                <th></th><th></th><th></th><th></th><th></th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td>John</td>
                                                <td>Doe</td>
                                                <td>john@example.com</td>
                                                <td></td><td></td><td></td><td></td><td></td>

                                                <td></td><td></td><td></td><td></td><td></td>
                                            </tr>
                                            <tr>
                                                <td>Mary</td>
                                                <td>Moe</td>
                                                <td>mary@example.com</td>
                                                <td></td><td></td><td></td><td></td><td></td>

                                                <td></td><td></td><td></td><td></td><td></td>
                                            </tr>
                                            <tr>
                                                <td>July</td>
                                                <td>Dooley</td>
                                                <td>july@example.com</td>
                                                <td></td><td></td><td></td><td></td><td></td>

                                                <td></td><td></td><td></td><td></td><td></td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                       


<!--                                        <pre>reportList={{reportList | json}}</pre>-->
                                    </div>
                                </div>

                            </form>
<!--                            <pre>oilMaster={{oilMaster | json}}</pre>-->

                        </div> <!--//End of my tab1//-->
                    </div>


                </div>
            </div>
        </div>

        <?php
    }



    function get_report_by_date(){
        $post_data =json_decode(file_get_contents("php://input"), true);
        $result=$this->report_model->select_report_details_by_date_to_date($post_data['start_date'],$post_data['end_date'])->result_array();
        $report_array['records']=$result;
        echo json_encode($report_array,JSON_NUMERIC_CHECK);

    }


    function get_sale_by_month(){
        $result=$this->sale_model->select_sale_mont_wise()->result_array();
        echo json_encode($result);

    }









}
?>