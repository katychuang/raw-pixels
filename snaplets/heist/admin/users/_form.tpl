<dfErrorList ref=""/>

<dfInputHidden ref="id"/>
<div class="form-group">
<dfLabel class="control-label" ref="login">Login</dfLabel>
<dfInputText class="form-control" ref="login" />
<dfErrorList ref="login"/>
</div>

<div class="form-group">
<dfLabel class="control-label" ref="email">Email</dfLabel>
<dfInputText class="form-control" ref="email" />
<dfErrorList ref="email"/>
</div>

<dfSubView ref="pass">
<div class="form-group">
<dfLabel class="control-label" ref="pass">Password</dfLabel>
<dfInputPassword class="form-control" ref="pass" />
<dfErrorList ref="pass"/>
</div>

<div class="form-group">
<dfLabel class="control-label" ref="pass_conf">Confirm Password</dfLabel>
<dfInputPassword class="form-control" ref="pass_conf" />
<dfErrorList ref="pass_conf"/>
</div>
</dfSubView>

<div class="form-actions">
  <dfInputSubmit class="btn btn-success" value="Save"/>
  <a href="${usersItemShowPath}" class="btn">Cancel</a>
</div>
