<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Customer extends CI_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('session');
        $this -> load -> model('person');
        $this -> load -> model('customer_model');
       // $this -> is_logged_in();
    }
    function is_logged_in() {
		$is_logged_in = $this -> session -> userdata('is_logged_in');
		if (!isset($is_logged_in) || $is_logged_in != 1) {
			echo 'you have no permission to use developer area'. '<a href="">Login</a>';
            print_r($this->session->all_userdata());
			die();
		}
	}

    public function angular_view_customer(){
        ?>
                <style type="text/css">
                    .navbar-fixed-top {
                        border: none;
                        background: #ac2925;

                        margin-top: -20px;
                    }
                    .navbar-fixed-top a{
                        color: #a6e1ec;
                    }
                    #vendor-div{
                        margin-top: 0px;
                    }
                    h1{
                        color: blue;
                    }
                    #mySidenav a[ng-click]{
                        cursor: pointer;
                        position: absolute;
                        left: -20px;
                        transition: 0.3s;
                        padding: 15px;
                        width: 140px;
                        text-decoration: none;
                        font-size: 15px;
                        color: white;
                        border-radius: 0 5px 5px 0;
                        background-color: #ac2925;
                    }

                    #mySidenav a[ng-click]:hover {
                        left: 0;
                    }

                    #mySidenav a:hover {
                        left: 0;
                    }
                    #new-vendor {
                        top: 20px;
                        background-color: #4CAF50;
                    }

                    #update-vendor {
                        top: 78px;
                        background-color: #2196F3;
                    }

                    #show-vendor{
                        top: 136px;
                        background-color: #f44336;
                    }
                    #main-working-div h1{
                        color: darkblue;
                    }
                    #vendor-form input{
                        border-radius: 5px;
                    }
                    #vendorForm{
                        margin-top: 10px;
                     }
                     input.ng-invalid {
                        background-color: pink;
                    }
    </style>
    <div class="container-fluid">
        <div class="row">

        <div class="d-flex col-12" ng-include="'application/views/header.html'"></div>


            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="customer-div">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs nav-justified indigo" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link " data-toggle="tab" href="#" role="tab" ng-click="setTab(1)"><i class="fa fa-user" ></i> New Customer</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#" role="tab" ng-click="setTab(2)"><i class="fa fa-heart"></i> Customer List</a>
                    </li>
                </ul>
                <!-- Tab panels -->
                <div class="tab-content">
                    <!--Panel 1-->
                    <div ng-show="isSet(1)">
                        <div id="my-tab-1">
                            <form name="customer_form">
                                <div class="row col-12">
                                    <div class="col-6 left-div">
                        
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Customer Name <span class="text-danger">*</span></label>
                                            <input class="col-6"  type="text" ng-change="customer.customer_name= (customer.customer_name | capitalize)" placeholder="Customer Name" ng-model="customer.customer_name" required>
                                        </div>

                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Mobile No.</label>
                                            <input type="text" class="col-6" ng-model="customer.mobile_no">
                                        </div>
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Email</label>
                                            <input type="email" name="myField"  class="col-6" ng-model="customer.email">
                                        </div>
                                       
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Aadhar No</label>
                                            <input type="text" class="col-6" ng-model="customer.aadhar_no">
                                        </div>
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Pan No <span class="text-danger">*</span></label>
                                            <input type="text" class="col-3"  ng-model="customer.pan_no" required>
                                            <div class="col-5" ng-messages="customer_form.pan.$error" role="alert">
                                                <div class="text-danger" ng-message-exp="['pattern']">Check format AAAAA9999A</div>
                                            </div>
                                        </div>
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">GST No</label>
                                            <input type="text" class="col-3"  ng-model="customer.gst_number" >
                                            <div class="col-5" ng-messages="customer_form.pan.$error" role="alert">
                                                <div class="text-danger" ng-message-exp="['pattern']">Check format AAAAA9999A</div>
                                            </div>
                                        </div>
                                        <div class="row col-12"></div>
                                    </div>
                                    <div class="col-6 right-div">
                                        <div class="row col-12 mt-2">
                                            <label class="col-4">Address <span class="text-danger">*</span></label>
                                            <input class="col-6" type="text"  ng-model="customer.address" required>
                                            <div class="col-2" ng-messages="customer_form.address.$error" role="alert">
                                                <div ng-message-exp="['required']">This is required</div>
                                        </div>
                                    </div>

                                    
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">City</label>
                                            <input class="col-6" type="text" ng-model="customer.city">
                                        </div>
                                      
                                       
                                        <div class="row col-12 mt-1">
                                            <label class="col-4">State</label>
                                            <select class="col-6" ng-change="selectStates(customer.state_id)"
                                                    ng-model="customer.state_id" >
                                            <option value="{{state.state_id}}"  ng-repeat="state in states">  {{state.state_name}} </option>
                                            </select>
                                        </div>

                                        <div class="row col-12 mt-1">
                                            <label class="col-4">District</label>
                                            <select class="col-6"
                                                    ng-model="customer.district_id" >
                                            <option value="{{district.district_id}}"  ng-repeat="district in districts">  {{district.district_name}}</option>
                                            </select>
                                        </div>

                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Post office</label>
                                            <input class="col-4" type="text" ng-model="customer.pin">
                                        </div>

                                        <div class="row col-12 mt-1">
                                            <label class="col-4">Pin</label>
                                            <input class="col-4" type="text" ng-model="customer.post_office">
                                        </div>

                                      
                                        
                                    </div>
                                </div>
                                <div class="row col-12" ng-show="false">
                                    <div class="col-6">
                                        <input type="file" fileinput="file" filepreview="filepreview"/>
                                    </div>
                                    <div class="col-6">
                                        <img ng-src="{{filepreview}}" class="img-responsive" ng-show="filepreview"/>
                                    </div>
                                </div>

                             

                                <div class="d-flex">
                               
                                            <div class="col-6"></div>
                                            <div class="col-3 mt-1">
                                                <input type="submit" class="btn btn-success" value="Save" ng-show="!isUpdateable" ng-click="saveCustomer(customer)" ng-disabled="customer_form.$invalid">
                                                <input type="submit" class="btn btn-success" value="Update" ng-show="isUpdateable" ng-click="updateCustomerByCustomerId(customer)" ng-disabled="customer_form.$invalid">

                                                <input type="submit" class="btn btn-info" value="Reset"  ng-click="resetCustomer()" >
                                            </div>

                                            <!--  success message      -->
                                            <div class="col-3 alert alert-success alert-dismissible" ng-show="successMsg">
                                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                                                <strong>{{alertmessage}}</strong>
                                            </div>

                                          
                                </div>

                            </form>
                            <div ng-show="false">
                                <pre>customerList= {{customerList | json}}</pre>
                            </div>
                        </div> <!--//End of my tab1//-->
                    </div>
                    <!--/.Panel 1-->
                    <!--Panel 2-->
                    <div ng-show="isSet(2)">
                        <style type="text/css">
                            .bee{
                                background-color: #d9edf7;
                            }
                            .banana{
                                background-color: #c4e3f3;
                            }
                            #vendor-table-div table th{
                                background-color: #1b6d85;
                                color: #a6e1ec;
                                cursor: pointer;
                            }
                            a[ng-click]{
                                cursor: pointer;
                            }

                        </style>
                        <p><input type="text" ng-model="searchItem"><span class="glyphicon glyphicon-search"></span> Search </p>
                        <div id="customer-table-div">
                            <table cellpadding="0" cellspacing="0" class="table table-bordered">
                                <tr>
                                    <th>SL></th>
                                    <th ng-click="changeSorting('person_id')">ID<i class="glyphicon" ng-class="getIcon('person_id')"></i></th>
                                    <th ng-click="changeSorting('person_name')">Name<i class="glyphicon" ng-class="getIcon('person_name')"></i></th>
                                    <th ng-click="changeSorting('mobile_no')">Mobile<i class="glyphicon" ng-class="getIcon('mobile_no')"></i></th>
                                    <th ng-click="changeSorting('address')">Address<i class="glyphicon" ng-class="getIcon('address')"></i></th>
                                    <th ng-click="changeSorting('gst_number')">GST no<i class="glyphicon" ng-class="getIcon('gst_number')"></i></th>
                                    <th ng-click="changeSorting('pan_no')">PAN No<i class="glyphicon" ng-class="getIcon('pan_no')"></i></th>
                                    <th>Edit</th>
                                </tr>
                                <tbody ng-repeat="customer in customerList | filter : searchItem  | orderBy:sort.active:sort.descending">
                                <tr ng-class-even="'banana'" ng-class-odd="'bee'">
                                    <td>{{ $index+1}}</td>
                                    <td>{{customer.person_id}}</td>
                                    <td>{{customer.customer_name}}</td>
                                    <td>{{customer.mobile_no}}</td>
                                    <td>{{customer.address}}</td>
                                    <td>{{customer.gst_number}}</td>
                                    <td>{{customer.pan_no}}</td>
                                    <td ng-click="updateCustomerFromTable(customer)"><a href="#"><i class="fa fa-pencil-square-o"></i></a></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

<!--                        <pre>customerList = {{customerList | json}}</pre>-->
<!--                        <pre>customer = {{customer | json}}</pre>-->
                    </div>
                    <!--/.Panel 2-->
                    <!--Panel 3-->
                    <div ng-show="isSet(3)">
                        This is our help area
                    </div>
                    <!--/.Panel 3-->
                </div>
            </div>

        </div>
    </div>







        <?php
    }


    
    function insert_customer(){
        $post_data =json_decode(file_get_contents("php://input"), true);
        $result=$this->customer_model->insert_new_customer((object)$post_data['customer']);
        $report_array['records']=$result;
        echo json_encode($report_array);
    }
    function update_customer_by_customer_id(){
        $post_data =json_decode(file_get_contents("php://input"), true);
        $result=$this->customer_model->update_customer_by_customer_id((object)$post_data['customer']);
        $report_array['records']=$result;
        echo json_encode($report_array);
    }



    public function get_districts(){
	    $post_data =(object)json_decode(file_get_contents("php://input"), true);

        $state_id=$post_data->stateID;
	      $result=$this->person->select_districts($state_id)->result_array();
          $report_array['records']=$result;
          echo json_encode($report_array);
	}
	public function get_states(){
	      $result=$this->person->select_states()->result_array();
          $report_array['records']=$result;
          echo json_encode($report_array);


	}
	public function get_customers(){
	    $result=$this->customer_model->select_customers()->result_array();
	    $report_array['records']=$result;
        echo json_encode($report_array);
	}
}
?>