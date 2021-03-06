<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Maestro Tokens</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<link rel="icon" href="favicon.ico" type="image/x-icon">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script type="text/javascript" src="web3.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
</head>
<body>
<div class="metamask err">Пожалуйста, установите <a href="https://metamask.io/" target="_blank">MetaMask</a></div>
<div class="row" align="center" style="margin-top: 20px;">
	<a href="?lang=ru">RU</a> <a href="?lang=en">EN</a>
    <img src="logo.png"><br><br>
    <b>1.</b>
	Купить <a href="https://rinkeby.etherscan.io/address/0xfb7764bfafa3603ca383b371ad7c77aaf4f34533" target="_blank">Maestro Tokens</a> за Эфиры: <br>
	<input type = "text" id = "inputEthers" style="width: 200px; text-align:right; padding-right:20px" value="0.01"><span class="eth">ETH</span><br>
    <button class="waves-effect waves-light btn buyButton">
        Купить
    </button><br><br>
	<div id="buymsg"></div>	
	<br><br><br>	
	
	 <b>2.</b>Отправить сообщение за 10 токенов:<br>
	<input type = "text" id = "inputString" style="width: 250px; text-align:center"><br>
	<button class="waves-effect waves-light btn sendMsg">
		Отправить
	</button><br><br>
	<div id="sendmsgmsg"></div>
</div>
<style>
.btn {
	cursor: pointer; 
	background-color: darkred; 
	color:gold
}
.eth {
	border-bottom: 1px solid #9e9e9e;
	padding-bottom: 13px;
}

.err {
	background-color:pink;
	color: darkred;
	padding: 20px 10px;
	border: 1px darkred solid;
	display:inline-block;
}
.ok {
	background-color:lightgreen;
	color: darkgreen;
	padding: 20px 10px;
	border: 1px darkgreen solid;
	display:inline-block;
}
.metamask {
	display:none;
}


</style>


<script>

    $(document).ready(function () {

        let Web3 = require('web3');
        if (typeof web3 !== 'undefined') {
            web3 = new Web3(web3.currentProvider);
            console.log('MetaMask installed');
        }
        else {
            $('.row').hide();
			$('.metamask').show();
        }
		


        $(".buyButton").click(function () {

            const contractAddress = "0x64Af8F808b8b0886080C89FA544f95965a973563";
			var abi = [{"constant":true,"inputs":[],"name":"buyPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"buy","outputs":[{"name":"","type":"uint256"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_token","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"}];
			var MyContract = web3.eth.contract(abi);
			var myContractInstance = MyContract.at(contractAddress);
			var events = myContractInstance.allEvents([{},], function(error, log){
			  if (error) console.log(error);
			});
			
            web3.eth.sendTransaction({
                    to: contractAddress,
                    from: web3.eth.accounts[0],
                    value: web3.toWei($('#inputEthers').val(), "ether")
                },
                function (error, response) {
					if(response) {
						$('#buymsg').html("<div class='ok'><a href='https://rinkeby.etherscan.io/tx/"+ response + "' target='_blank'>Транзакция</a> создана. Спасибо за вашу покупку!</div>");
					}
                    if(error) {
						$('#buymsg').html("<div class='err'>Ошибка</div>");
					}
                }
            );
        });
		
		
		$(".sendMsg").click(function(){

			let Web3 = require('web3');
			if (typeof web3 !== 'undefined'){
				web3 = new Web3(web3.currentProvider);
			}
			else {
				alert('You have to install MetaMask !');
			}

			const abi = [{"constant":false,"inputs":[{"name":"_message","type":"string"}],"name":"setMessage","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_price","type":"uint256"}],"name":"setPrice","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"price","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"lastDonator","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"message","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_token","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}];
			const contractAddress = "0x02279E21454eE1ac2b43dC949aFd74E50136265A";
			
			let MyContract = web3.eth.contract(abi);
			let myContractInstance = MyContract.at(contractAddress);
			let functionData = myContractInstance.setMessage.getData($('#inputString').val());
			web3.eth.sendTransaction({
					to:contractAddress,
					from:web3.eth.accounts[0],
					data: functionData,
				},
				function(error, response){
					if(response) {
						$('#sendmsgmsg').html("<div class='ok'><a href='https://rinkeby.etherscan.io/tx/"+ response +"' target='_blank'>Транзакция</a> создана. Спасибо за ваше сообщение!</div>")
					}
                    if(error) {
						$('#sendmsgmsg').html("<div class='err'>Ошибка</div>");
					}
				});
		});
		
		
    });
</script>
</body>
</html>