# import the GPG pub key

gpg import salt-master.pub

# encrypt data

`echo -n "supersecret" | gpg --armor --batch --trust-model always --encrypt -r saltmaster`

# bash function

```
function salt-encryt {
	if [ -n "${1}" ]
	then
		echo -n "${1}" | gpg --armor --batch --trust-model always --encrypt -r saltmaster
	else
		echo "You must provide a text to encryt as parameter (between '\"' if there is space in it)."
	done
}
```
