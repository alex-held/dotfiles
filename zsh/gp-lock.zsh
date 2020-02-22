gp-lock () 
{
    echo "Encrypting file '$1' -> '$1.asc'"
    gpg --encrypt --sign --armor -r gpg@alexheld.io $1
    rm $1
}

gp-unlock () 
{
    echo "Decrypting file '$1' -> '$2'"
    gpg --decrypt $1 > $2
}
