select top 2 * from Trasfer_Bank
where  SourceAccount=100 or TargetAccount=100

select top 2 * from Trasfer_Bank
where  SourceAccount=100 or TargetAccount=100
order by updated

 create proc view_transferamount
	 as
	 begin
	 select *from Trasfer_Bank
	 end

	 drop procedure Transaction_usp
	 select * from AccountDetails
	 select *from Trasfer_Bank

	 create proc Transaction_usp
	 (
	 @TransferId bigint out ,
	  @SourceAccount bigint,
	  @TargetAccount bigint,
	  @TransitionType varchar(30),
	  @TransferAmount int,
	  @update date,
	  @comments varchar(40))
	  
	  as
	  begin
	  
	  --deposit--
	  if @TransitionType='Deposit'
	     begin 
		 insert into Trasfer_Bank (SourceAccount,TransitionType,updated,TransferAmount,comments) values(@SourceAccount,@TransitionType,@update,@TransferAmount,@comments)
		 update AccountDetails 
		 set Balanace=Balanace+(@TransferAmount)
		 where AccountId=@SourceAccount
		 end

	  if @TransitionType='Withdraw'
	     begin 
		 insert into Trasfer_Bank (SourceAccount,TransitionType,updated,TransferAmount,comments) values(@SourceAccount,@TransitionType,@update,@TransferAmount,@comments)
         update AccountDetails 
		 set Balanace=Balanace-(@TransferAmount)
		 where AccountId=@SourceAccount and Balanace>=@TransferAmount;
		 end
	else select -2

		  if @TransitionType='Transfer'
	     begin 
		 insert into Trasfer_Bank (SourceAccount,TargetAccount,TransitionType,updated,TransferAmount,comments) values(@SourceAccount,@TargetAccount,@TransitionType,@update,@TransferAmount,@comments)
         
		  update AccountDetails 
		  set Balanace=Balanace-(@TransferAmount)
		  where AccountId=@SourceAccount and  Balanace>=@TransferAmount;

		  update AccountDetails 
		  set Balanace=Balanace+(@TransferAmount)
		  where AccountId=@TargetAccount and @SourceAccount in(select AccountId from AccountDetails where AccountId=@SourceAccount and  Balanace>=@TransferAmount)
		  end
		  else select -3;

end

select * from AccountDetails

exec Transaction_usp 1,100,null,'Withdraw',20000,'2013-3-3','ad'

select * from CustomerCreation



create proc print_last(@AccountId bigint)
as
begin
select top 2 * from Trasfer_Bank
where  SourceAccount=@AccountId or TargetAccount=@AccountId
end
drop procedure print_last

create proc print_by_date(@AccountId bigint)
as
begin
select top 2 * from Trasfer_Bank
where  SourceAccount=@AccountId or TargetAccount=@AccountId
order by updated
end
	  exec print_by_date 100