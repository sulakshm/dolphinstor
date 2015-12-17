# ADMIN node, one Admin node is necessary and cannot be changed.
MASTER=1 # can edit this to as many as needed, minimum 1
MINIONS=3 # can edit this to as many as needed, minimum 3

sed -i.bak "s/\(.*\)count=.*/\1count=${MASTER}/" demo-master.tf
sed -i.bak "s/\(.*\)count=.*/\1count=${MINIONS}/" demo-minion.tf

echo "Ensure terraform.tfvars is updated with right DO credentials"
echo "Logs are at make.out"
echo "Creating a cluster with 1 Admin, $MASTER masters and $MINIONS minion nodes"

rc=$(terraform apply 2>&1 > make.out)

if [ "$rc" == "" ]; then
  echo "cluster creation OK."
else
  echo "cluster creation FAIL($rc). See make.out for details."
fi

for i in `ls *.bak`
do
    mv $i `basename $i .bak`
done
